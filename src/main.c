/**
 * @file main.c
 * @brief ORT Vulnerability Analysis Test Project
 *
 * Projet de test pour l'analyse de vulnérabilité avec OSS Review Toolkit.
 * Intègre les bibliothèques embarquées cibles pour la cible STM32U5.
 */

/* CMSIS Device */
#include "cmsis_device.h"

/* STM32U5 HAL */
#include "stm32u5xx_hal.h"

/* FreeRTOS */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

/* BTstack */
#include "btstack.h"

/* TinyUSB */
#include "tusb.h"

/* NNoM - Neural Network on Microcontrollers */
#include "nnom.h"

/* -------------------------------------------------------------------------- */
/* Tâche FreeRTOS : exemple minimal                                            */
/* -------------------------------------------------------------------------- */

static void vLedTask(void *pvParameters)
{
    (void)pvParameters;

    for (;;)
    {
        /* Bascule d'une LED via HAL GPIO (GPIO stub) */
        HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_5);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

static void vUsbTask(void *pvParameters)
{
    (void)pvParameters;

    /* Initialisation TinyUSB */
    tusb_init();

    for (;;)
    {
        tud_task(); /* TinyUSB device task */
        vTaskDelay(pdMS_TO_TICKS(1));
    }
}

/* -------------------------------------------------------------------------- */
/* Point d'entrée                                                              */
/* -------------------------------------------------------------------------- */

int main(void)
{
    /* Initialisation HAL STM32U5 */
    HAL_Init();

    /* Initialisation BTstack */
    btstack_memory_init();
    btstack_run_loop_init(btstack_run_loop_embedded_get_instance());

    /* Création des tâches FreeRTOS */
    xTaskCreate(vLedTask,  "LED",  128, NULL, tskIDLE_PRIORITY + 1, NULL);
    xTaskCreate(vUsbTask,  "USB",  256, NULL, tskIDLE_PRIORITY + 2, NULL);

    /* Démarrage du scheduler */
    vTaskStartScheduler();

    /* Ne doit jamais être atteint */
    for (;;) {}

    return 0;
}
