/*
 * FreeRTOSConfig.h
 * Configuration minimale FreeRTOS pour STM32U5 (Cortex-M33)
 */
#ifndef FREERTOS_CONFIG_H
#define FREERTOS_CONFIG_H

/* Scheduler */
#define configUSE_PREEMPTION                    1
#define configUSE_TIME_SLICING                  1
#define configUSE_PORT_OPTIMISED_TASK_SELECTION 0
#define configUSE_TICKLESS_IDLE                 0

/* Clock */
#define configCPU_CLOCK_HZ                      ( ( unsigned long ) 160000000 )
#define configTICK_RATE_HZ                      ( ( TickType_t ) 1000 )

/* Memory */
#define configTOTAL_HEAP_SIZE                   ( ( size_t ) ( 64 * 1024 ) )
#define configMINIMAL_STACK_SIZE                ( ( uint16_t ) 128 )

/* Tasks */
#define configMAX_PRIORITIES                    ( 7 )
#define configMAX_TASK_NAME_LEN                 ( 16 )
#define configUSE_16_BIT_TICKS                  0

/* Hooks */
#define configUSE_IDLE_HOOK                     0
#define configUSE_TICK_HOOK                     0
#define configCHECK_FOR_STACK_OVERFLOW          2
#define configUSE_MALLOC_FAILED_HOOK            1

/* Mutexes / semaphores */
#define configUSE_MUTEXES                       1
#define configUSE_RECURSIVE_MUTEXES             1
#define configUSE_COUNTING_SEMAPHORES           1
#define configUSE_QUEUE_SETS                    0

/* Timers logiciels */
#define configUSE_TIMERS                        1
#define configTIMER_TASK_PRIORITY               ( configMAX_PRIORITIES - 1 )
#define configTIMER_QUEUE_LENGTH                10
#define configTIMER_TASK_STACK_DEPTH            configMINIMAL_STACK_SIZE

/* Cortex-M33 : priorités NVIC */
#define configLIBRARY_LOWEST_INTERRUPT_PRIORITY         15
#define configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY    5
#define configKERNEL_INTERRUPT_PRIORITY         ( configLIBRARY_LOWEST_INTERRUPT_PRIORITY << (8 - 4) )
#define configMAX_SYSCALL_INTERRUPT_PRIORITY    ( configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY << (8 - 4) )

/* Assertions */
#define configASSERT( x ) if( ( x ) == 0 ) { taskDISABLE_INTERRUPTS(); for(;;); }

/* Compatibilité API */
#define INCLUDE_vTaskDelay                      1
#define INCLUDE_vTaskDelayUntil                 1
#define INCLUDE_uxTaskGetStackHighWaterMark     1
#define INCLUDE_xTaskGetCurrentTaskHandle       1
#define INCLUDE_vTaskDelete                     1
#define INCLUDE_vTaskSuspend                    1

#endif /* FREERTOS_CONFIG_H */
