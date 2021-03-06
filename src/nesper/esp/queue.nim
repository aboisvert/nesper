##
##     FreeRTOS V8.2.0 - Copyright (C) 2015 Real Time Engineers Ltd.
##     All rights reserved
##
##     VISIT http://www.FreeRTOS.org TO ENSURE YOU ARE USING THE LATEST VERSION.
##
##     This file is part of the FreeRTOS distribution.
##
##     FreeRTOS is free software; you can redistribute it and/or modify it under
##     the terms of the GNU General Public License (version 2) as published by the
##     Free Software Foundation >>!AND MODIFIED BY!<< the FreeRTOS exception.
##
## **************************************************************************
##     >>!   NOTE: The modification to the GPL is included to allow you to     !<<
##     >>!   distribute a combined work that includes FreeRTOS without being   !<<
##     >>!   obliged to provide the source code for proprietary components     !<<
##     >>!   outside of the FreeRTOS kernel.                                   !<<
## **************************************************************************
##
##     FreeRTOS is distributed in the hope that it will be useful, but WITHOUT ANY
##     WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
##     FOR A PARTICULAR PURPOSE.  Full license text is available on the following
##     link: http://www.freertos.org/a00114.html
##
## **************************************************************************
##                                                                        *
##     FreeRTOS provides completely free yet professionally developed,    *
##     robust, strictly quality controlled, supported, and cross          *
##     platform software that is more than just the market leader, it     *
##     is the industry's de facto standard.                               *
##                                                                        *
##     Help yourself get started quickly while simultaneously helping     *
##     to support the FreeRTOS project by purchasing a FreeRTOS           *
##     tutorial book, reference manual, or both:                          *
##     http://www.FreeRTOS.org/Documentation                              *
##                                                                        *
## **************************************************************************
##
##     http://www.FreeRTOS.org/FAQHelp.html - Having a problem?  Start by reading
## 	the FAQ page "My application does not run, what could be wrong?".  Have you
## 	defined configASSERT()?
##
## 	http://www.FreeRTOS.org/support - In return for receiving this top quality
## 	embedded software for free we request you assist our global community by
## 	participating in the support forum.
##
## 	http://www.FreeRTOS.org/training - Investing in training allows your team to
## 	be as productive as possible as early as possible.  Now you can receive
## 	FreeRTOS training directly from Richard Barry, CEO of Real Time Engineers
## 	Ltd, and the world's leading authority on the world's leading RTOS.
##
##     http://www.FreeRTOS.org/plus - A selection of FreeRTOS ecosystem products,
##     including FreeRTOS+Trace - an indispensable productivity tool, a DOS
##     compatible FAT file system, and our tiny thread aware UDP/IP stack.
##
##     http://www.FreeRTOS.org/labs - Where new FreeRTOS products go to incubate.
##     Come and try FreeRTOS+TCP, our new open source TCP/IP stack for FreeRTOS.
##
##     http://www.OpenRTOS.com - Real Time Engineers ltd. license FreeRTOS to High
##     Integrity Systems ltd. to sell under the OpenRTOS brand.  Low cost OpenRTOS
##     licenses offer ticketed support, indemnification and commercial middleware.
##
##     http://www.SafeRTOS.com - High Integrity Systems also provide a safety
##     engineered and independently SIL3 certified version for use in safety and
##     mission critical applications that require provable dependability.
##
##     1 tab == 4 spaces!
##

import ../consts
# import os
# {.compile: "nqueue.c".}
# const qheader = currentSourcePath().splitPath.head & "/defs/nqueue.h"
const qheader = """#include <freertos/FreeRTOS.h>
                   #include "freertos/queue.h" """

## *
##  Type by which queues are referenced.  For example, a call to xQueueCreate()
##  returns an QueueHandle_t variable that can then be used as a parameter to
##  xQueueSend(), xQueueReceive(), etc.
##
type
  QueueHandle_t* {.importc: "$1", header: qheader.} = pointer
  StaticQueue_t* {.importc: "$1", header: qheader.} = pointer

## *
##  Type by which queue sets are referenced.  For example, a call to
##  xQueueCreateSet() returns an xQueueSet variable that can then be used as a
##  parameter to xQueueSelectFromSet(), xQueueAddToSet(), etc.
##
type
  QueueSetHandle_t* {.importc: "$1", header: qheader.} = pointer

## *
##  Queue sets can contain both queues and semaphores, so the
##  QueueSetMemberHandle_t is defined as a type to be used where a parameter or
##  return value can be either an QueueHandle_t or an SemaphoreHandle_t.
##
type
  QueueSetMemberHandle_t* {.importc: "$1", header: qheader.} = pointer


# ## * @cond
# ##  For internal use only.

# const
#   queueSEND_TO_BACK* = (cast[BaseType_t](0))
#   queueSEND_TO_FRONT* = (cast[BaseType_t](1))
#   queueOVERWRITE* = (cast[BaseType_t](2))

##  For internal use only.  These definitions *must* match those in queue.c.

# const
#   queueQUEUE_TYPE_BASE* = (cast[uint8](0))
#   queueQUEUE_TYPE_SET* = (cast[uint8](0))
#   queueQUEUE_TYPE_MUTEX* = (cast[uint8](1))
#   queueQUEUE_TYPE_COUNTING_SEMAPHORE* = (cast[uint8](2))
#   queueQUEUE_TYPE_BINARY_SEMAPHORE* = (cast[uint8](3))
#   queueQUEUE_TYPE_RECURSIVE_MUTEX* = (cast[uint8](4))

## * @endcond
## *
##  Creates a new queue instance.  This allocates the storage required by the
##  new queue and returns a handle for the queue.
##
##  @param uxQueueLength The maximum number of items that the queue can contain.
##
##  @param uxItemSize The number of bytes each item in the queue will require.
##  Items are queued by copy, not by reference, so this is the number of bytes
##  that will be copied for each posted item.  Each item on the queue must be
##  the same size.
##
##  @return If the queue is successfully create then a handle to the newly
##  created queue is returned.  If the queue cannot be created then 0 is
##  returned.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##   char ucMessageID;
##   char ucData[ 20 ];
##   };
##
##   void vATask( void *pvParameters )
##   {
##   QueueHandle_t xQueue1, xQueue2;
##
##   // Create a queue capable of containing 10 uint32 values.
##   xQueue1 = xQueueCreate( 10, sizeof( uint32 ) );
##   if( xQueue1 == 0 )
##   {
##       // Queue was not created and must not be used.
##   }
##
##   // Create a queue capable of containing 10 pointers to AMessage structures.
##   // These should be passed by pointer as they contain a lot of data.
##   xQueue2 = xQueueCreate( 10, sizeof( struct AMessage * ) );
##   if( xQueue2 == 0 )
##   {
##       // Queue was not created and must not be used.
##   }
##
##   // ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueCreate*(uxQueueLength, uxItemSize: UBaseType_t): QueueHandle_t {.importc: "$1", header: qheader.}

## *
##  Creates a new queue instance, and returns a handle by which the new queue
##  can be referenced.
##
##  Internally, within the FreeRTOS implementation, queues use two blocks of
##  memory.  The first block is used to hold the queue's data structures.  The
##  second block is used to hold items placed into the queue.  If a queue is
##  created using xQueueCreate() then both blocks of memory are automatically
##  dynamically allocated inside the xQueueCreate() function.  (see
##  http://www.freertos.org/a00111.html).  If a queue is created using
##  xQueueCreateStatic() then the application writer must provide the memory that
##  will get used by the queue.  xQueueCreateStatic() therefore allows a queue to
##  be created without using any dynamic memory allocation.
##
##  http://www.FreeRTOS.org/Embedded-RTOS-Queues.html
##
##  @param uxQueueLength The maximum number of items that the queue can contain.
##
##  @param uxItemSize The number of bytes each item in the queue will require.
##  Items are queued by copy, not by reference, so this is the number of bytes
##  that will be copied for each posted item.  Each item on the queue must be
##  the same size.
##
##  @param pucQueueStorage If uxItemSize is not zero then
##  pucQueueStorageBuffer must point to a uint8 array that is at least large
##  enough to hold the maximum number of items that can be in the queue at any
##  one time - which is ( uxQueueLength * uxItemsSize ) bytes.  If uxItemSize is
##  zero then pucQueueStorageBuffer can be NULL.
##
##  @param pxQueueBuffer Must point to a variable of type StaticQueue_t, which
##  will be used to hold the queue's data structure.
##
##  @return If the queue is created then a handle to the created queue is
##  returned.  If pxQueueBuffer is NULL then NULL is returned.
##
##  Example usage:
##  @code{c}
##  struct AMessage
##  {
##   char ucMessageID;
##   char ucData[ 20 ];
##  };
##
##  #define QUEUE_LENGTH 10
##  #define ITEM_SIZE sizeof( uint32 )
##
##  // xQueueBuffer will hold the queue structure.
##  StaticQueue_t xQueueBuffer;
##
##  // ucQueueStorage will hold the items posted to the queue.  Must be at least
##  // [(queue length) * ( queue item size)] bytes long.
##  uint8 ucQueueStorage[ QUEUE_LENGTH * ITEM_SIZE ];
##
##  void vATask( void *pvParameters )
##  {
##   QueueHandle_t xQueue1;
##
##   // Create a queue capable of containing 10 uint32 values.
##   xQueue1 = xQueueCreate( QUEUE_LENGTH, // The number of items the queue can hold.
##                           ITEM_SIZE     // The size of each item in the queue
##                           &( ucQueueStorage[ 0 ] ), // The buffer that will hold the items in the queue.
##                           &xQueueBuffer ); // The buffer that will hold the queue structure.
##
##   // The queue is guaranteed to be created successfully as no dynamic memory
##   // allocation is used.  Therefore xQueue1 is now a handle to a valid queue.
##
##   // ... Rest of task code.
##  }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueCreateStatic*(uxQueueLength: UBaseType_t, uxItemSize: UBaseType_t, pucQueueStorage: pointer,
                            pxQueueBuffer: ptr StaticQueue_t): QueueHandle_t {.importc: "$1", header: qheader.}


## *
##  This is a macro that calls xQueueGenericSend().
##
##  Post an item to the front of a queue.  The item is queued by copy, not by
##  reference.  This function must not be called from an interrupt service
##  routine.  See xQueueSendFromISR () for an alternative which may be used
##  in an ISR.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param xTicksToWait The maximum amount of time the task should block
##  waiting for space to become available on the queue, should it already
##  be full.  The call will return immediately if this is set to 0 and the
##  queue is full.  The time is defined in tick periods so the constant
##  portTICK_PERIOD_MS should be used to convert to real time if this is required.
##
##  @return pdTRUE if the item was successfully posted, otherwise errQUEUE_FULL.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##   char ucMessageID;
##   char ucData[ 20 ];
##   } xMessage;
##
##   uint32 ulVar = 10UL;
##
##   void vATask( void *pvParameters )
##   {
##   QueueHandle_t xQueue1, xQueue2;
##   struct AMessage *pxMessage;
##
##   // Create a queue capable of containing 10 uint32 values.
##   xQueue1 = xQueueCreate( 10, sizeof( uint32 ) );
##
##   // Create a queue capable of containing 10 pointers to AMessage structures.
##   // These should be passed by pointer as they contain a lot of data.
##   xQueue2 = xQueueCreate( 10, sizeof( struct AMessage * ) );
##
##   // ...
##
##   if( xQueue1 != 0 )
##   {
##       // Send an uint32.  Wait for 10 ticks for space to become
##       // available if necessary.
##       if( xQueueSendToFront( xQueue1, ( void * ) &ulVar, ( TickType_t ) 10 ) != pdPASS )
##       {
##           // Failed to post the message, even after 10 ticks.
##       }
##   }
##
##   if( xQueue2 != 0 )
##   {
##       // Send a pointer to a struct AMessage object.  Don't block if the
##       // queue is already full.
##       pxMessage = & xMessage;
##       xQueueSendToFront( xQueue2, ( void * ) &pxMessage, ( TickType_t ) 0 );
##   }
##
##   // ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueSendToFront*(
  xQueue: QueueHandle_t,
  pvItemToQueue: pointer,
  xTicksToWait: TickType_t):
    BaseType_t {.importc: "$1", header: qheader.}


## *
##  This is a macro that calls xQueueGenericSend().
##
##  Post an item to the back of a queue.  The item is queued by copy, not by
##  reference.  This function must not be called from an interrupt service
##  routine.  See xQueueSendFromISR () for an alternative which may be used
##  in an ISR.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param xTicksToWait The maximum amount of time the task should block
##  waiting for space to become available on the queue, should it already
##  be full.  The call will return immediately if this is set to 0 and the queue
##  is full.  The  time is defined in tick periods so the constant
##  portTICK_PERIOD_MS should be used to convert to real time if this is required.
##
##  @return pdTRUE if the item was successfully posted, otherwise errQUEUE_FULL.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##   char ucMessageID;
##   char ucData[ 20 ];
##   } xMessage;
##
##   uint32 ulVar = 10UL;
##
##   void vATask( void *pvParameters )
##   {
##   QueueHandle_t xQueue1, xQueue2;
##   struct AMessage *pxMessage;
##
##   // Create a queue capable of containing 10 uint32 values.
##   xQueue1 = xQueueCreate( 10, sizeof( uint32 ) );
##
##   // Create a queue capable of containing 10 pointers to AMessage structures.
##   // These should be passed by pointer as they contain a lot of data.
##   xQueue2 = xQueueCreate( 10, sizeof( struct AMessage * ) );
##
##   // ...
##
##   if( xQueue1 != 0 )
##   {
##       // Send an uint32.  Wait for 10 ticks for space to become
##       // available if necessary.
##       if( xQueueSendToBack( xQueue1, ( void * ) &ulVar, ( TickType_t ) 10 ) != pdPASS )
##       {
##           // Failed to post the message, even after 10 ticks.
##       }
##   }
##
##   if( xQueue2 != 0 )
##   {
##       // Send a pointer to a struct AMessage object.  Don't block if the
##       // queue is already full.
##       pxMessage = & xMessage;
##       xQueueSendToBack( xQueue2, ( void * ) &pxMessage, ( TickType_t ) 0 );
##   }
##
##   // ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueSendToBack*(xQueue: QueueHandle_t, pvItemToQueue: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}


## *
##  This is a macro that calls xQueueGenericSend().  It is included for
##  backward compatibility with versions of FreeRTOS.org that did not
##  include the xQueueSendToFront() and xQueueSendToBack() macros.  It is
##  equivalent to xQueueSendToBack().
##
##  Post an item on a queue.  The item is queued by copy, not by reference.
##  This function must not be called from an interrupt service routine.
##  See xQueueSendFromISR () for an alternative which may be used in an ISR.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param xTicksToWait The maximum amount of time the task should block
##  waiting for space to become available on the queue, should it already
##  be full.  The call will return immediately if this is set to 0 and the
##  queue is full.  The time is defined in tick periods so the constant
##  portTICK_PERIOD_MS should be used to convert to real time if this is required.
##
##  @return pdTRUE if the item was successfully posted, otherwise errQUEUE_FULL.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##   char ucMessageID;
##   char ucData[ 20 ];
##   } xMessage;
##
##   uint32 ulVar = 10UL;
##
##   void vATask( void *pvParameters )
##   {
##   QueueHandle_t xQueue1, xQueue2;
##   struct AMessage *pxMessage;
##
##   // Create a queue capable of containing 10 uint32 values.
##   xQueue1 = xQueueCreate( 10, sizeof( uint32 ) );
##
##   // Create a queue capable of containing 10 pointers to AMessage structures.
##   // These should be passed by pointer as they contain a lot of data.
##   xQueue2 = xQueueCreate( 10, sizeof( struct AMessage * ) );
##
##   // ...
##
##   if( xQueue1 != 0 )
##   {
##       // Send an uint32.  Wait for 10 ticks for space to become
##       // available if necessary.
##       if( xQueueSend( xQueue1, ( void * ) &ulVar, ( TickType_t ) 10 ) != pdPASS )
##       {
##           // Failed to post the message, even after 10 ticks.
##       }
##   }
##
##   if( xQueue2 != 0 )
##   {
##       // Send a pointer to a struct AMessage object.  Don't block if the
##       // queue is already full.
##       pxMessage = & xMessage;
##       xQueueSend( xQueue2, ( void * ) &pxMessage, ( TickType_t ) 0 );
##   }
##
##   // ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueSend*(xQueue: QueueHandle_t, pvItemToQueue: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}


## *
##  Only for use with queues that have a length of one - so the queue is either
##  empty or full.
##
##  Post an item on a queue.  If the queue is already full then overwrite the
##  value held in the queue.  The item is queued by copy, not by reference.
##
##  This function must not be called from an interrupt service routine.
##  See xQueueOverwriteFromISR () for an alternative which may be used in an ISR.
##
##  @param xQueue The handle of the queue to which the data is being sent.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @return xQueueOverwrite() is a macro that calls xQueueGenericSend(), and
##  therefore has the same return values as xQueueSendToFront().  However, pdPASS
##  is the only value that can be returned because xQueueOverwrite() will write
##  to the queue even when the queue is already full.
##
##  Example usage:
##  @code{c}
##
##   void vFunction( void *pvParameters )
##   {
##   QueueHandle_t xQueue;
##   uint32 ulVarToSend, ulValReceived;
##
##   // Create a queue to hold one uint32 value.  It is strongly
##   // recommended *not* to use xQueueOverwrite() on queues that can
##   // contain more than one value, and doing so will trigger an assertion
##   // if configASSERT() is defined.
##   xQueue = xQueueCreate( 1, sizeof( uint32 ) );
##
##   // Write the value 10 to the queue using xQueueOverwrite().
##   ulVarToSend = 10;
##   xQueueOverwrite( xQueue, &ulVarToSend );
##
##   // Peeking the queue should now return 10, but leave the value 10 in
##   // the queue.  A block time of zero is used as it is known that the
##   // queue holds a value.
##   ulValReceived = 0;
##   xQueuePeek( xQueue, &ulValReceived, 0 );
##
##   if( ulValReceived != 10 )
##   {
##       // Error unless the item was removed by a different task.
##   }
##
##   // The queue is still full.  Use xQueueOverwrite() to overwrite the
##   // value held in the queue with 100.
##   ulVarToSend = 100;
##   xQueueOverwrite( xQueue, &ulVarToSend );
##
##   // This time read from the queue, leaving the queue empty once more.
##   // A block time of 0 is used again.
##   xQueueReceive( xQueue, &ulValReceived, 0 );
##
##   // The value read should be the last value written, even though the
##   // queue was already full when the value was written.
##   if( ulValReceived != 100 )
##   {
##       // Error!
##   }
##
##   // ...
##  }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueOverwrite*(xQueue: QueueHandle_t, pvItemToQueue: pointer): BaseType_t {.importc: "$1", header: qheader.}


## *
##  It is preferred that the macros xQueueSend(), xQueueSendToFront() and
##  xQueueSendToBack() are used in place of calling this function directly.
##
##  Post an item on a queue.  The item is queued by copy, not by reference.
##  This function must not be called from an interrupt service routine.
##  See xQueueSendFromISR () for an alternative which may be used in an ISR.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param xTicksToWait The maximum amount of time the task should block
##  waiting for space to become available on the queue, should it already
##  be full.  The call will return immediately if this is set to 0 and the
##  queue is full.  The time is defined in tick periods so the constant
##  portTICK_PERIOD_MS should be used to convert to real time if this is required.
##
##  @param xCopyPosition Can take the value queueSEND_TO_BACK to place the
##  item at the back of the queue, or queueSEND_TO_FRONT to place the item
##  at the front of the queue (for high priority messages).
##
##  @return pdTRUE if the item was successfully posted, otherwise errQUEUE_FULL.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##   char ucMessageID;
##   char ucData[ 20 ];
##   } xMessage;
##
##   uint32 ulVar = 10UL;
##
##   void vATask( void *pvParameters )
##   {
##   QueueHandle_t xQueue1, xQueue2;
##   struct AMessage *pxMessage;
##
##   // Create a queue capable of containing 10 uint32 values.
##   xQueue1 = xQueueCreate( 10, sizeof( uint32 ) );
##
##   // Create a queue capable of containing 10 pointers to AMessage structures.
##   // These should be passed by pointer as they contain a lot of data.
##   xQueue2 = xQueueCreate( 10, sizeof( struct AMessage * ) );
##
##   // ...
##
##   if( xQueue1 != 0 )
##   {
##       // Send an uint32.  Wait for 10 ticks for space to become
##       // available if necessary.
##       if( xQueueGenericSend( xQueue1, ( void * ) &ulVar, ( TickType_t ) 10, queueSEND_TO_BACK ) != pdPASS )
##       {
##           // Failed to post the message, even after 10 ticks.
##       }
##   }
##
##   if( xQueue2 != 0 )
##   {
##       // Send a pointer to a struct AMessage object.  Don't block if the
##       // queue is already full.
##       pxMessage = & xMessage;
##       xQueueGenericSend( xQueue2, ( void * ) &pxMessage, ( TickType_t ) 0, queueSEND_TO_BACK );
##   }
##
##   // ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueGenericSend*(xQueue: QueueHandle_t; pvItemToQueue: pointer;
                       xTicksToWait: TickType_t; xCopyPosition: BaseType_t): BaseType_t {.
    importc: "xQueueGenericSend", header: qheader.}



## *
##  This is a macro that calls the xQueueGenericReceive() function.
##
##  Receive an item from a queue without removing the item from the queue.
##  The item is received by copy so a buffer of adequate size must be
##  provided.  The number of bytes copied into the buffer was defined when
##  the queue was created.
##
##  Successfully received items remain on the queue so will be returned again
##  by the next call, or a call to xQueueReceive().
##
##  This macro must not be used in an interrupt service routine.  See
##  xQueuePeekFromISR() for an alternative that can be called from an interrupt
##  service routine.
##
##  @param xQueue The handle to the queue from which the item is to be
##  received.
##
##  @param pvBuffer Pointer to the buffer into which the received item will
##  be copied.
##
##  @param xTicksToWait The maximum amount of time the task should block
##  waiting for an item to receive should the queue be empty at the time
##  of the call.	 The time is defined in tick periods so the constant
##  portTICK_PERIOD_MS should be used to convert to real time if this is required.
##  xQueuePeek() will return immediately if xTicksToWait is 0 and the queue
##  is empty.
##
##  @return pdTRUE if an item was successfully received from the queue,
##  otherwise pdFALSE.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##   char ucMessageID;
##   char ucData[ 20 ];
##   } xMessage;
##
##   QueueHandle_t xQueue;
##
##   // Task to create a queue and post a value.
##   void vATask( void *pvParameters )
##   {
##   struct AMessage *pxMessage;
##
##   // Create a queue capable of containing 10 pointers to AMessage structures.
##   // These should be passed by pointer as they contain a lot of data.
##   xQueue = xQueueCreate( 10, sizeof( struct AMessage * ) );
##   if( xQueue == 0 )
##   {
##       // Failed to create the queue.
##   }
##
##   // ...
##
##   // Send a pointer to a struct AMessage object.  Don't block if the
##   // queue is already full.
##   pxMessage = & xMessage;
##   xQueueSend( xQueue, ( void * ) &pxMessage, ( TickType_t ) 0 );
##
##   // ... Rest of task code.
##   }
##
##   // Task to peek the data from the queue.
##   void vADifferentTask( void *pvParameters )
##   {
##   struct AMessage *pxRxedMessage;
##
##   if( xQueue != 0 )
##   {
##       // Peek a message on the created queue.  Block for 10 ticks if a
##       // message is not immediately available.
##       if( xQueuePeek( xQueue, &( pxRxedMessage ), ( TickType_t ) 10 ) )
##       {
##           // pcRxedMessage now points to the struct AMessage variable posted
##           // by vATask, but the item still remains on the queue.
##       }
##   }
##
##   // ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueuePeek*(xQueue: QueueHandle_t, pvBuffer: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}


## *
##  A version of xQueuePeek() that can be called from an interrupt service
##  routine (ISR).
##
##  Receive an item from a queue without removing the item from the queue.
##  The item is received by copy so a buffer of adequate size must be
##  provided.  The number of bytes copied into the buffer was defined when
##  the queue was created.
##
##  Successfully received items remain on the queue so will be returned again
##  by the next call, or a call to xQueueReceive().
##
##  @param xQueue The handle to the queue from which the item is to be
##  received.
##
##  @param pvBuffer Pointer to the buffer into which the received item will
##  be copied.
##
##  @return pdTRUE if an item was successfully received from the queue,
##  otherwise pdFALSE.
##
##  \ingroup QueueManagement
##

proc xQueuePeekFromISR*(xQueue: QueueHandle_t; pvBuffer: pointer): BaseType_t {.importc: "$1", header: qheader.}



## *
##  queue. h
##  <pre>
##  BaseType_t xQueueReceive(
## 								 QueueHandle_t xQueue,
## 								 void *pvBuffer,
## 								 TickType_t xTicksToWait
## 							);</pre>
##
##  This is a macro that calls the xQueueGenericReceive() function.
##
##  Receive an item from a queue.  The item is received by copy so a buffer of
##  adequate size must be provided.  The number of bytes copied into the buffer
##  was defined when the queue was created.
##
##  Successfully received items are removed from the queue.
##
##  This function must not be used in an interrupt service routine.  See
##  xQueueReceiveFromISR for an alternative that can.
##
##  @param xQueue The handle to the queue from which the item is to be
##  received.
##
##  @param pvBuffer Pointer to the buffer into which the received item will
##  be copied.
##
##  @param xTicksToWait The maximum amount of time the task should block
##  waiting for an item to receive should the queue be empty at the time
##  of the call.	 xQueueReceive() will return immediately if xTicksToWait
##  is zero and the queue is empty.  The time is defined in tick periods so the
##  constant portTICK_PERIOD_MS should be used to convert to real time if this is
##  required.
##
##  @return pdTRUE if an item was successfully received from the queue,
##  otherwise pdFALSE.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##  	char ucMessageID;
##  	char ucData[ 20 ];
##   } xMessage;
##
##   QueueHandle_t xQueue;
##
##   // Task to create a queue and post a value.
##   void vATask( void *pvParameters )
##   {
##   struct AMessage *pxMessage;
##
##  	// Create a queue capable of containing 10 pointers to AMessage structures.
##  	// These should be passed by pointer as they contain a lot of data.
##  	xQueue = xQueueCreate( 10, sizeof( struct AMessage * ) );
##  	if( xQueue == 0 )
##  	{
##  		// Failed to create the queue.
##  	}
##
##  	// ...
##
##  	// Send a pointer to a struct AMessage object.  Don't block if the
##  	// queue is already full.
##  	pxMessage = & xMessage;
##  	xQueueSend( xQueue, ( void * ) &pxMessage, ( TickType_t ) 0 );
##
##  	// ... Rest of task code.
##   }
##
##   // Task to receive from the queue.
##   void vADifferentTask( void *pvParameters )
##   {
##   struct AMessage *pxRxedMessage;
##
##  	if( xQueue != 0 )
##  	{
##  		// Receive a message on the created queue.  Block for 10 ticks if a
##  		// message is not immediately available.
##  		if( xQueueReceive( xQueue, &( pxRxedMessage ), ( TickType_t ) 10 ) )
##  		{
##  			// pcRxedMessage now points to the struct AMessage variable posted
##  			// by vATask.
##  		}
##  	}
##
##  	// ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueReceive*(xQueue: QueueHandle_t, pvBuffer: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}



## *
##  It is preferred that the macro xQueueReceive() be used rather than calling
##  this function directly.
##
##  Receive an item from a queue.  The item is received by copy so a buffer of
##  adequate size must be provided.  The number of bytes copied into the buffer
##  was defined when the queue was created.
##
##  This function must not be used in an interrupt service routine.  See
##  xQueueReceiveFromISR for an alternative that can.
##
##  @param xQueue The handle to the queue from which the item is to be
##  received.
##
##  @param pvBuffer Pointer to the buffer into which the received item will
##  be copied.
##
##  @param xTicksToWait The maximum amount of time the task should block
##  waiting for an item to receive should the queue be empty at the time
##  of the call.	 The time is defined in tick periods so the constant
##  portTICK_PERIOD_MS should be used to convert to real time if this is required.
##  xQueueGenericReceive() will return immediately if the queue is empty and
##  xTicksToWait is 0.
##
##  @param xJustPeek When set to true, the item received from the queue is not
##  actually removed from the queue - meaning a subsequent call to
##  xQueueReceive() will return the same item.  When set to false, the item
##  being received from the queue is also removed from the queue.
##
##  @return pdTRUE if an item was successfully received from the queue,
##  otherwise pdFALSE.
##
##  Example usage:
##  @code{c}
##   struct AMessage
##   {
##  	char ucMessageID;
##  	char ucData[ 20 ];
##   } xMessage;
##
##   QueueHandle_t xQueue;
##
##   // Task to create a queue and post a value.
##   void vATask( void *pvParameters )
##   {
##   struct AMessage *pxMessage;
##
##  	// Create a queue capable of containing 10 pointers to AMessage structures.
##  	// These should be passed by pointer as they contain a lot of data.
##  	xQueue = xQueueCreate( 10, sizeof( struct AMessage * ) );
##  	if( xQueue == 0 )
##  	{
##  		// Failed to create the queue.
##  	}
##
##  	// ...
##
##  	// Send a pointer to a struct AMessage object.  Don't block if the
##  	// queue is already full.
##  	pxMessage = & xMessage;
##  	xQueueSend( xQueue, ( void * ) &pxMessage, ( TickType_t ) 0 );
##
##  	// ... Rest of task code.
##   }
##
##   // Task to receive from the queue.
##   void vADifferentTask( void *pvParameters )
##   {
##   struct AMessage *pxRxedMessage;
##
##  	if( xQueue != 0 )
##  	{
##  		// Receive a message on the created queue.  Block for 10 ticks if a
##  		// message is not immediately available.
##  		if( xQueueGenericReceive( xQueue, &( pxRxedMessage ), ( TickType_t ) 10 ) )
##  		{
##  			// pcRxedMessage now points to the struct AMessage variable posted
##  			// by vATask.
##  		}
##  	}
##
##  	// ... Rest of task code.
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueGenericReceive*(xQueue: QueueHandle_t; pvBuffer: pointer;
                          xTicksToWait: TickType_t; xJustPeek: BaseType_t): BaseType_t {.
    importc: "xQueueGenericReceive", header: qheader.}


## *
##  Return the number of messages stored in a queue.
##
##  @param xQueue A handle to the queue being queried.
##
##  @return The number of messages available in the queue.
##
##  \ingroup QueueManagement
##

proc uxQueueMessagesWaiting*(xQueue: QueueHandle_t): UBaseType_t {.importc: "uxQueueMessagesWaiting", header: qheader.}


## *
##  Return the number of free spaces available in a queue.  This is equal to the
##  number of items that can be sent to the queue before the queue becomes full
##  if no items are removed.
##
##  @param xQueue A handle to the queue being queried.
##
##  @return The number of spaces available in the queue.
##
##  \ingroup QueueManagement
##

proc uxQueueSpacesAvailable*(xQueue: QueueHandle_t): UBaseType_t {.importc: "uxQueueSpacesAvailable", header: qheader.}



## *
##  Delete a queue - freeing all the memory allocated for storing of items
##  placed on the queue.
##
##  @param xQueue A handle to the queue to be deleted.
##
##  \ingroup QueueManagement
##

proc vQueueDelete*(xQueue: QueueHandle_t) {.importc: "vQueueDelete", header: qheader.}



## *
##  This is a macro that calls xQueueGenericSendFromISR().
##
##  Post an item to the front of a queue.  It is safe to use this macro from
##  within an interrupt service routine.
##
##  Items are queued by copy not reference so it is preferable to only
##  queue small items, especially when called from an ISR.  In most cases
##  it would be preferable to store a pointer to the item being queued.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param[out] pxHigherPriorityTaskWoken xQueueSendToFrontFromISR() will set
##  *pxHigherPriorityTaskWoken to pdTRUE if sending to the queue caused a task
##  to unblock, and the unblocked task has a priority higher than the currently
##  running task.  If xQueueSendToFromFromISR() sets this value to pdTRUE then
##  a context switch should be requested before the interrupt is exited.
##
##  @return pdTRUE if the data was successfully sent to the queue, otherwise
##  errQUEUE_FULL.
##
##  Example usage for buffered IO (where the ISR can obtain more than one value
##  per call):
##  @code{c}
##   void vBufferISR( void )
##   {
##   char cIn;
##   BaseType_t xHigherPrioritTaskWoken;
##
##  	// We have not woken a task at the start of the ISR.
##  	xHigherPriorityTaskWoken = pdFALSE;
##
##  	// Loop until the buffer is empty.
##  	do
##  	{
##  		// Obtain a byte from the buffer.
##  		cIn = portINPUT_BYTE( RX_REGISTER_ADDRESS );
##
##  		// Post the byte.
##  		xQueueSendToFrontFromISR( xRxQueue, &cIn, &xHigherPriorityTaskWoken );
##
##  	} while( portINPUT_BYTE( BUFFER_COUNT ) );
##
##  	// Now the buffer is empty we can switch context if necessary.
##  	if( xHigherPriorityTaskWoken )
##  	{
##  		portYIELD_FROM_ISR ();
##  	}
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueSendToFrontFromISR*(xQueue: QueueHandle_t, pvItemToQueue: pointer, pxHigherPriorityTaskWoken: ptr BaseType_t): BaseType_t {.importc: "$1", header: qheader.}



## *
##  This is a macro that calls xQueueGenericSendFromISR().
##
##  Post an item to the back of a queue.  It is safe to use this macro from
##  within an interrupt service routine.
##
##  Items are queued by copy not reference so it is preferable to only
##  queue small items, especially when called from an ISR.  In most cases
##  it would be preferable to store a pointer to the item being queued.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param[out] pxHigherPriorityTaskWoken xQueueSendToBackFromISR() will set
##  *pxHigherPriorityTaskWoken to pdTRUE if sending to the queue caused a task
##  to unblock, and the unblocked task has a priority higher than the currently
##  running task.  If xQueueSendToBackFromISR() sets this value to pdTRUE then
##  a context switch should be requested before the interrupt is exited.
##
##  @return pdTRUE if the data was successfully sent to the queue, otherwise
##  errQUEUE_FULL.
##
##  Example usage for buffered IO (where the ISR can obtain more than one value
##  per call):
##  @code{c}
##   void vBufferISR( void )
##   {
##   char cIn;
##   BaseType_t xHigherPriorityTaskWoken;
##
##  	// We have not woken a task at the start of the ISR.
##  	xHigherPriorityTaskWoken = pdFALSE;
##
##  	// Loop until the buffer is empty.
##  	do
##  	{
##  		// Obtain a byte from the buffer.
##  		cIn = portINPUT_BYTE( RX_REGISTER_ADDRESS );
##
##  		// Post the byte.
##  		xQueueSendToBackFromISR( xRxQueue, &cIn, &xHigherPriorityTaskWoken );
##
##  	} while( portINPUT_BYTE( BUFFER_COUNT ) );
##
##  	// Now the buffer is empty we can switch context if necessary.
##  	if( xHigherPriorityTaskWoken )
##  	{
##  		portYIELD_FROM_ISR ();
##  	}
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueSendToBackFromISR*(xQueue: QueueHandle_t, pvItemToQueue: pointer, pxHigherPriorityTaskWoken: ptr BaseType_t): BaseType_t {.importc: "$1", header: qheader.}



## *
##  A version of xQueueOverwrite() that can be used in an interrupt service
##  routine (ISR).
##
##  Only for use with queues that can hold a single item - so the queue is either
##  empty or full.
##
##  Post an item on a queue.  If the queue is already full then overwrite the
##  value held in the queue.  The item is queued by copy, not by reference.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param[out] pxHigherPriorityTaskWoken xQueueOverwriteFromISR() will set
##  *pxHigherPriorityTaskWoken to pdTRUE if sending to the queue caused a task
##  to unblock, and the unblocked task has a priority higher than the currently
##  running task.  If xQueueOverwriteFromISR() sets this value to pdTRUE then
##  a context switch should be requested before the interrupt is exited.
##
##  @return xQueueOverwriteFromISR() is a macro that calls
##  xQueueGenericSendFromISR(), and therefore has the same return values as
##  xQueueSendToFrontFromISR().  However, pdPASS is the only value that can be
##  returned because xQueueOverwriteFromISR() will write to the queue even when
##  the queue is already full.
##
##  Example usage:
##  @code{c}
##   QueueHandle_t xQueue;
##
##   void vFunction( void *pvParameters )
##   {
##   	// Create a queue to hold one uint32 value.  It is strongly
##  	// recommended *not* to use xQueueOverwriteFromISR() on queues that can
##  	// contain more than one value, and doing so will trigger an assertion
##  	// if configASSERT() is defined.
##  	xQueue = xQueueCreate( 1, sizeof( uint32 ) );
##  }
##
##  void vAnInterruptHandler( void )
##  {
##  // xHigherPriorityTaskWoken must be set to pdFALSE before it is used.
##  BaseType_t xHigherPriorityTaskWoken = pdFALSE;
##  uint32 ulVarToSend, ulValReceived;
##
##  	// Write the value 10 to the queue using xQueueOverwriteFromISR().
##  	ulVarToSend = 10;
##  	xQueueOverwriteFromISR( xQueue, &ulVarToSend, &xHigherPriorityTaskWoken );
##
##  	// The queue is full, but calling xQueueOverwriteFromISR() again will still
##  	// pass because the value held in the queue will be overwritten with the
##  	// new value.
##  	ulVarToSend = 100;
##  	xQueueOverwriteFromISR( xQueue, &ulVarToSend, &xHigherPriorityTaskWoken );
##
##  	// Reading from the queue will now return 100.
##
##  	// ...
##
##  	if( xHigherPrioritytaskWoken == pdTRUE )
##  	{
##  		// Writing to the queue caused a task to unblock and the unblocked task
##  		// has a priority higher than or equal to the priority of the currently
##  		// executing task (the task this interrupt interrupted).  Perform a context
##  		// switch so this interrupt returns directly to the unblocked task.
##  		portYIELD_FROM_ISR(); // or portEND_SWITCHING_ISR() depending on the port.
##  	}
##  }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueOverwriteFromISR*(xQueue: QueueHandle_t, pvItemToQueue: pointer, pxHigherPriorityTaskWoken: ptr BaseType_t): BaseType_t {.importc: "$1", header: qheader.}



## *
##  This is a macro that calls xQueueGenericSendFromISR().  It is included
##  for backward compatibility with versions of FreeRTOS.org that did not
##  include the xQueueSendToBackFromISR() and xQueueSendToFrontFromISR()
##  macros.
##
##  Post an item to the back of a queue.  It is safe to use this function from
##  within an interrupt service routine.
##
##  Items are queued by copy not reference so it is preferable to only
##  queue small items, especially when called from an ISR.  In most cases
##  it would be preferable to store a pointer to the item being queued.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param[out] pxHigherPriorityTaskWoken xQueueSendFromISR() will set
##  *pxHigherPriorityTaskWoken to pdTRUE if sending to the queue caused a task
##  to unblock, and the unblocked task has a priority higher than the currently
##  running task.  If xQueueSendFromISR() sets this value to pdTRUE then
##  a context switch should be requested before the interrupt is exited.
##
##  @return pdTRUE if the data was successfully sent to the queue, otherwise
##  errQUEUE_FULL.
##
##  Example usage for buffered IO (where the ISR can obtain more than one value
##  per call):
##  @code{c}
##   void vBufferISR( void )
##   {
##   char cIn;
##   BaseType_t xHigherPriorityTaskWoken;
##
##  	// We have not woken a task at the start of the ISR.
##  	xHigherPriorityTaskWoken = pdFALSE;
##
##  	// Loop until the buffer is empty.
##  	do
##  	{
##  		// Obtain a byte from the buffer.
##  		cIn = portINPUT_BYTE( RX_REGISTER_ADDRESS );
##
##  		// Post the byte.
##  		xQueueSendFromISR( xRxQueue, &cIn, &xHigherPriorityTaskWoken );
##
##  	} while( portINPUT_BYTE( BUFFER_COUNT ) );
##
##  	// Now the buffer is empty we can switch context if necessary.
##  	if( xHigherPriorityTaskWoken )
##  	{
##  		// Actual macro used here is port specific.
##  		portYIELD_FROM_ISR ();
##  	}
##   }
##  @endcode
##
##  \ingroup QueueManagement
##


proc xQueueSendFromISR*(xQueue: QueueHandle_t, pvItemToQueue: pointer, pxHigherPriorityTaskWoken: ptr BaseType_t): BaseType_t {.importc: "$1", header: qheader.}



## *@{
## *
##  It is preferred that the macros xQueueSendFromISR(),
##  xQueueSendToFrontFromISR() and xQueueSendToBackFromISR() be used in place
##  of calling this function directly.  xQueueGiveFromISR() is an
##  equivalent for use by semaphores that don't actually copy any data.
##
##  Post an item on a queue.  It is safe to use this function from within an
##  interrupt service routine.
##
##  Items are queued by copy not reference so it is preferable to only
##  queue small items, especially when called from an ISR.  In most cases
##  it would be preferable to store a pointer to the item being queued.
##
##  @param xQueue The handle to the queue on which the item is to be posted.
##
##  @param pvItemToQueue A pointer to the item that is to be placed on the
##  queue.  The size of the items the queue will hold was defined when the
##  queue was created, so this many bytes will be copied from pvItemToQueue
##  into the queue storage area.
##
##  @param[out] pxHigherPriorityTaskWoken xQueueGenericSendFromISR() will set
##  *pxHigherPriorityTaskWoken to pdTRUE if sending to the queue caused a task
##  to unblock, and the unblocked task has a priority higher than the currently
##  running task.  If xQueueGenericSendFromISR() sets this value to pdTRUE then
##  a context switch should be requested before the interrupt is exited.
##
##  @param xCopyPosition Can take the value queueSEND_TO_BACK to place the
##  item at the back of the queue, or queueSEND_TO_FRONT to place the item
##  at the front of the queue (for high priority messages).
##
##  @return pdTRUE if the data was successfully sent to the queue, otherwise
##  errQUEUE_FULL.
##
##  Example usage for buffered IO (where the ISR can obtain more than one value
##  per call):
##  @code{c}
##   void vBufferISR( void )
##   {
##   char cIn;
##   BaseType_t xHigherPriorityTaskWokenByPost;
##
##  	// We have not woken a task at the start of the ISR.
##  	xHigherPriorityTaskWokenByPost = pdFALSE;
##
##  	// Loop until the buffer is empty.
##  	do
##  	{
##  		// Obtain a byte from the buffer.
##  		cIn = portINPUT_BYTE( RX_REGISTER_ADDRESS );
##
##  		// Post each byte.
##  		xQueueGenericSendFromISR( xRxQueue, &cIn, &xHigherPriorityTaskWokenByPost, queueSEND_TO_BACK );
##
##  	} while( portINPUT_BYTE( BUFFER_COUNT ) );
##
##  	// Now the buffer is empty we can switch context if necessary.  Note that the
##  	// name of the yield function required is port specific.
##  	if( xHigherPriorityTaskWokenByPost )
##  	{
##  		taskYIELD_YIELD_FROM_ISR();
##  	}
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueGenericSendFromISR*(xQueue: QueueHandle_t; pvItemToQueue: pointer;
                              pxHigherPriorityTaskWoken: ptr BaseType_t;
                              xCopyPosition: BaseType_t): BaseType_t {.
    importc: "xQueueGenericSendFromISR", header: qheader.}


proc xQueueGiveFromISR*(xQueue: QueueHandle_t; pxHigherPriorityTaskWoken: ptr BaseType_t): BaseType_t {.
    importc: "xQueueGiveFromISR", header: qheader.}


##  Receive an item from a queue.  It is safe to use this function from within an
##  interrupt service routine.
##
##  @param xQueue The handle to the queue from which the item is to be
##  received.
##
##  @param pvBuffer Pointer to the buffer into which the received item will
##  be copied.
##
##  @param[out] pxHigherPriorityTaskWoken A task may be blocked waiting for space to become
##  available on the queue.  If xQueueReceiveFromISR causes such a task to
##  unblock *pxTaskWoken will get set to pdTRUE, otherwise *pxTaskWoken will
##  remain unchanged.
##
##  @return pdTRUE if an item was successfully received from the queue,
##  otherwise pdFALSE.
##
##  Example usage:
##  @code{c}
##   QueueHandle_t xQueue;
##
##   // Function to create a queue and post some values.
##   void vAFunction( void *pvParameters )
##   {
##   char cValueToPost;
##   const TickType_t xTicksToWait = ( TickType_t )0xff;
##
##  	// Create a queue capable of containing 10 characters.
##  	xQueue = xQueueCreate( 10, sizeof( char ) );
##  	if( xQueue == 0 )
##  	{
##  		// Failed to create the queue.
##  	}
##
##  	// ...
##
##  	// Post some characters that will be used within an ISR.  If the queue
##  	// is full then this task will block for xTicksToWait ticks.
##  	cValueToPost = 'a';
##  	xQueueSend( xQueue, ( void * ) &cValueToPost, xTicksToWait );
##  	cValueToPost = 'b';
##  	xQueueSend( xQueue, ( void * ) &cValueToPost, xTicksToWait );
##
##  	// ... keep posting characters ... this task may block when the queue
##  	// becomes full.
##
##  	cValueToPost = 'c';
##  	xQueueSend( xQueue, ( void * ) &cValueToPost, xTicksToWait );
##   }
##
##   // ISR that outputs all the characters received on the queue.
##   void vISR_Routine( void )
##   {
##   BaseType_t xTaskWokenByReceive = pdFALSE;
##   char cRxedChar;
##
##  	while( xQueueReceiveFromISR( xQueue, ( void * ) &cRxedChar, &xTaskWokenByReceive) )
##  	{
##  		// A character was received.  Output the character now.
##  		vOutputCharacter( cRxedChar );
##
##  		// If removing the character from the queue woke the task that was
##  		// posting onto the queue cTaskWokenByReceive will have been set to
##  		// pdTRUE.  No matter how many times this loop iterates only one
##  		// task will be woken.
##  	}
##
##  	if( cTaskWokenByPost != ( char ) pdFALSE;
##  	{
##  		taskYIELD ();
##  	}
##   }
##  @endcode
##  \ingroup QueueManagement
##

proc xQueueReceiveFromISR*(xQueue: QueueHandle_t; pvBuffer: pointer;
                          pxHigherPriorityTaskWoken: ptr BaseType_t): BaseType_t {.
    importc: "xQueueReceiveFromISR", header: qheader.}


##  Utilities to query queues that are safe to use from an ISR.  These utilities
##  should be used only from witin an ISR, or within a critical section.
##

proc xQueueIsQueueEmptyFromISR*(xQueue: QueueHandle_t): BaseType_t {.
    importc: "xQueueIsQueueEmptyFromISR", header: qheader.}


proc xQueueIsQueueFullFromISR*(xQueue: QueueHandle_t): BaseType_t {.
    importc: "xQueueIsQueueFullFromISR", header: qheader.}


proc uxQueueMessagesWaitingFromISR*(xQueue: QueueHandle_t): UBaseType_t {.
    importc: "uxQueueMessagesWaitingFromISR", header: qheader.}

## *
##  xQueueAltGenericSend() is an alternative version of xQueueGenericSend().
##  Likewise xQueueAltGenericReceive() is an alternative version of
##  xQueueGenericReceive().
##
##  The source code that implements the alternative (Alt) API is much
##  simpler	because it executes everything from within a critical section.
##  This is	the approach taken by many other RTOSes, but FreeRTOS.org has the
##  preferred fully featured API too.  The fully featured API has more
##  complex	code that takes longer to execute, but makes much less use of
##  critical sections.  Therefore the alternative API sacrifices interrupt
##  responsiveness to gain execution speed, whereas the fully featured API
##  sacrifices execution speed to ensure better interrupt responsiveness.
##

proc xQueueAltGenericSend*(xQueue: QueueHandle_t; pvItemToQueue: pointer;
                          xTicksToWait: TickType_t; xCopyPosition: BaseType_t): BaseType_t {.
    importc: "$1", header: qheader.}

proc xQueueAltGenericReceive*(xQueue: QueueHandle_t; pvBuffer: pointer;
                             xTicksToWait: TickType_t; xJustPeeking: BaseType_t): BaseType_t {.
    importc: "xQueueAltGenericReceive", header: qheader.}


proc xQueueAltSendToFront*(xQueue: QueueHandle_t, pvItemToQueue: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}

proc xQueueAltSendToBack*(xQueue: QueueHandle_t, pvItemToQueue: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}

proc xQueueAltReceive*(xQueue: QueueHandle_t, pvBuffer: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}

proc xQueueAltPeek*(xQueue: QueueHandle_t, pvBuffer: pointer, xTicksToWait: TickType_t): BaseType_t {.importc: "$1", header: qheader.}

##
##  The functions defined above are for passing data to and from tasks.  The
##  functions below are the equivalents for passing data to and from
##  co-routines.
##
##  These functions are called from the co-routine macro implementation and
##  should not be called directly from application code.  Instead use the macro
##  wrappers defined within croutine.h.
##

proc xQueueCRSendFromISR*(xQueue: QueueHandle_t; pvItemToQueue: pointer;
                         xCoRoutinePreviouslyWoken: BaseType_t): BaseType_t {.
    importc: "xQueueCRSendFromISR", header: qheader.}

proc xQueueCRReceiveFromISR*(xQueue: QueueHandle_t; pvBuffer: pointer;
                            pxTaskWoken: ptr BaseType_t): BaseType_t {.
    importc: "xQueueCRReceiveFromISR", header: qheader.}

proc xQueueCRSend*(xQueue: QueueHandle_t; pvItemToQueue: pointer;
                  xTicksToWait: TickType_t): BaseType_t {.
    importc: "xQueueCRSend", header: qheader.}

proc xQueueCRReceive*(xQueue: QueueHandle_t; pvBuffer: pointer;
                     xTicksToWait: TickType_t): BaseType_t {.
    importc: "xQueueCRReceive", header: qheader.}



##  Reset a queue back to its original empty state.  pdPASS is returned if the
##  queue is successfully reset.  pdFAIL is returned if the queue could not be
##  reset because there are tasks blocked on the queue waiting to either
##  receive from the queue or send to the queue.
##
##  @param xQueue The queue to reset
##  @return always returns pdPASS
##

proc xQueueReset*(xQueue: QueueHandle_t): BaseType_t {.importc: "$1", header: qheader.}

## *
##  The registry is provided as a means for kernel aware debuggers to
##  locate queues, semaphores and mutexes.  Call vQueueAddToRegistry() add
##  a queue, semaphore or mutex handle to the registry if you want the handle
##  to be available to a kernel aware debugger.  If you are not using a kernel
##  aware debugger then this function can be ignored.
##
##  configQUEUE_REGISTRY_SIZE defines the maximum number of handles the
##  registry can hold.  configQUEUE_REGISTRY_SIZE must be greater than 0
##  within FreeRTOSConfig.h for the registry to be available.  Its value
##  does not effect the number of queues, semaphores and mutexes that can be
##  created - just the number that the registry can hold.
##
##  @param xQueue The handle of the queue being added to the registry.  This
##  is the handle returned by a call to xQueueCreate().  Semaphore and mutex
##  handles can also be passed in here.
##
##  @param pcName The name to be associated with the handle.  This is the
##  name that the kernel aware debugger will display.  The queue registry only
##  stores a pointer to the string - so the string must be persistent (global or
##  preferably in ROM/Flash), not on the stack.
##

proc vQueueAddToRegistry*(xQueue: QueueHandle_t; pcName: cstring) {.
    importc: "vQueueAddToRegistry", header: qheader.}


## *
##  The registry is provided as a means for kernel aware debuggers to
##  locate queues, semaphores and mutexes.  Call vQueueAddToRegistry() add
##  a queue, semaphore or mutex handle to the registry if you want the handle
##  to be available to a kernel aware debugger, and vQueueUnregisterQueue() to
##  remove the queue, semaphore or mutex from the register.  If you are not using
##  a kernel aware debugger then this function can be ignored.
##
##  @param xQueue The handle of the queue being removed from the registry.
##

proc vQueueUnregisterQueue*(xQueue: QueueHandle_t) {.
    importc: "vQueueUnregisterQueue", header: qheader.}


## *
##  @note This function has been back ported from FreeRTOS v9.0.0
##
##  The queue registry is provided as a means for kernel aware debuggers to
##  locate queues, semaphores and mutexes.  Call pcQueueGetName() to look
##  up and return the name of a queue in the queue registry from the queue's
##  handle.
##
##  @param xQueue The handle of the queue the name of which will be returned.
##  @return If the queue is in the registry then a pointer to the name of the
##  queue is returned.  If the queue is not in the registry then NULL is
##  returned.
##

proc pcQueueGetName*(xQueue: QueueHandle_t): cstring {.
    importc: "pcQueueGetName", header: qheader.}


## *
##  Generic version of the function used to creaet a queue using dynamic memory
##  allocation.  This is called by other functions and macros that create other
##  RTOS objects that use the queue structure as their base.
##

proc xQueueGenericCreate*(uxQueueLength: UBaseType_t; uxItemSize: UBaseType_t;
                          ucQueueType: uint8): QueueHandle_t {.
    importc: "xQueueGenericCreate", header: qheader.}



##  Generic version of the function used to creaet a queue using dynamic memory
##  allocation.  This is called by other functions and macros that create other
##  RTOS objects that use the queue structure as their base.
##

proc xQueueGenericCreateStatic*(uxQueueLength: UBaseType_t;
                                uxItemSize: UBaseType_t;
                                pucQueueStorage: ptr uint8;
                                pxStaticQueue: ptr StaticQueue_t;
                                ucQueueType: uint8): QueueHandle_t {.
    importc: "xQueueGenericCreateStatic", header: qheader.}



## *
##  Queue sets provide a mechanism to allow a task to block (pend) on a read
##  operation from multiple queues or semaphores simultaneously.
##
##  See FreeRTOS/Source/Demo/Common/Minimal/QueueSet.c for an example using this
##  function.
##
##  A queue set must be explicitly created using a call to xQueueCreateSet()
##  before it can be used.  Once created, standard FreeRTOS queues and semaphores
##  can be added to the set using calls to xQueueAddToSet().
##  xQueueSelectFromSet() is then used to determine which, if any, of the queues
##  or semaphores contained in the set is in a state where a queue read or
##  semaphore take operation would be successful.
##
##  Note 1:  See the documentation on http://wwwFreeRTOS.org/RTOS-queue-sets.html
##  for reasons why queue sets are very rarely needed in practice as there are
##  simpler methods of blocking on multiple objects.
##
##  Note 2:  Blocking on a queue set that contains a mutex will not cause the
##  mutex holder to inherit the priority of the blocked task.
##
##  Note 3:  An additional 4 bytes of RAM is required for each space in a every
##  queue added to a queue set.  Therefore counting semaphores that have a high
##  maximum count value should not be added to a queue set.
##
##  Note 4:  A receive (in the case of a queue) or take (in the case of a
##  semaphore) operation must not be performed on a member of a queue set unless
##  a call to xQueueSelectFromSet() has first returned a handle to that set member.
##
##  @param uxEventQueueLength Queue sets store events that occur on
##  the queues and semaphores contained in the set.  uxEventQueueLength specifies
##  the maximum number of events that can be queued at once.  To be absolutely
##  certain that events are not lost uxEventQueueLength should be set to the
##  total sum of the length of the queues added to the set, where binary
##  semaphores and mutexes have a length of 1, and counting semaphores have a
##  length set by their maximum count value.  Examples:
##   + If a queue set is to hold a queue of length 5, another queue of length 12,
##     and a binary semaphore, then uxEventQueueLength should be set to
##     (5 + 12 + 1), or 18.
##   + If a queue set is to hold three binary semaphores then uxEventQueueLength
##     should be set to (1 + 1 + 1 ), or 3.
##   + If a queue set is to hold a counting semaphore that has a maximum count of
##     5, and a counting semaphore that has a maximum count of 3, then
##     uxEventQueueLength should be set to (5 + 3), or 8.
##
##  @return If the queue set is created successfully then a handle to the created
##  queue set is returned.  Otherwise NULL is returned.
##

proc xQueueCreateSet*(uxEventQueueLength: UBaseType_t): QueueSetHandle_t {.
    importc: "xQueueCreateSet", header: qheader.}



## *
##  Adds a queue or semaphore to a queue set that was previously created by a
##  call to xQueueCreateSet().
##
##  See FreeRTOS/Source/Demo/Common/Minimal/QueueSet.c for an example using this
##  function.
##
##  Note 1:  A receive (in the case of a queue) or take (in the case of a
##  semaphore) operation must not be performed on a member of a queue set unless
##  a call to xQueueSelectFromSet() has first returned a handle to that set member.
##
##  @param xQueueOrSemaphore The handle of the queue or semaphore being added to
##  the queue set (cast to an QueueSetMemberHandle_t type).
##
##  @param xQueueSet The handle of the queue set to which the queue or semaphore
##  is being added.
##
##  @return If the queue or semaphore was successfully added to the queue set
##  then pdPASS is returned.  If the queue could not be successfully added to the
##  queue set because it is already a member of a different queue set then pdFAIL
##  is returned.
##

proc xQueueAddToSet*(xQueueOrSemaphore: QueueSetMemberHandle_t;
                    xQueueSet: QueueSetHandle_t): BaseType_t {.
    importc: "xQueueAddToSet", header: qheader.}




## *
##  Removes a queue or semaphore from a queue set.  A queue or semaphore can only
##  be removed from a set if the queue or semaphore is empty.
##
##  See FreeRTOS/Source/Demo/Common/Minimal/QueueSet.c for an example using this
##  function.
##
##  @param xQueueOrSemaphore The handle of the queue or semaphore being removed
##  from the queue set (cast to an QueueSetMemberHandle_t type).
##
##  @param xQueueSet The handle of the queue set in which the queue or semaphore
##  is included.
##
##  @return If the queue or semaphore was successfully removed from the queue set
##  then pdPASS is returned.  If the queue was not in the queue set, or the
##  queue (or semaphore) was not empty, then pdFAIL is returned.
##

proc xQueueRemoveFromSet*(xQueueOrSemaphore: QueueSetMemberHandle_t;
                         xQueueSet: QueueSetHandle_t): BaseType_t {.
    importc: "xQueueRemoveFromSet", header: qheader.}




## *
##  xQueueSelectFromSet() selects from the members of a queue set a queue or
##  semaphore that either contains data (in the case of a queue) or is available
##  to take (in the case of a semaphore).  xQueueSelectFromSet() effectively
##  allows a task to block (pend) on a read operation on all the queues and
##  semaphores in a queue set simultaneously.
##
##  See FreeRTOS/Source/Demo/Common/Minimal/QueueSet.c for an example using this
##  function.
##
##  Note 1:  See the documentation on http://wwwFreeRTOS.org/RTOS-queue-sets.html
##  for reasons why queue sets are very rarely needed in practice as there are
##  simpler methods of blocking on multiple objects.
##
##  Note 2:  Blocking on a queue set that contains a mutex will not cause the
##  mutex holder to inherit the priority of the blocked task.
##
##  Note 3:  A receive (in the case of a queue) or take (in the case of a
##  semaphore) operation must not be performed on a member of a queue set unless
##  a call to xQueueSelectFromSet() has first returned a handle to that set member.
##
##  @param xQueueSet The queue set on which the task will (potentially) block.
##
##  @param xTicksToWait The maximum time, in ticks, that the calling task will
##  remain in the Blocked state (with other tasks executing) to wait for a member
##  of the queue set to be ready for a successful queue read or semaphore take
##  operation.
##
##  @return xQueueSelectFromSet() will return the handle of a queue (cast to
##  a QueueSetMemberHandle_t type) contained in the queue set that contains data,
##  or the handle of a semaphore (cast to a QueueSetMemberHandle_t type) contained
##  in the queue set that is available, or NULL if no such queue or semaphore
##  exists before before the specified block time expires.
##

proc xQueueSelectFromSet*(xQueueSet: QueueSetHandle_t; xTicksToWait: TickType_t): QueueSetMemberHandle_t {.
    importc: "xQueueSelectFromSet", header: qheader.}



## *
##  A version of xQueueSelectFromSet() that can be used from an ISR.
##

proc xQueueSelectFromSetFromISR*(xQueueSet: QueueSetHandle_t): QueueSetMemberHandle_t {.
    importc: "xQueueSelectFromSetFromISR", header: qheader.}


# ##  Not public API functions.

# proc vQueueWaitForMessageRestricted*(xQueue: QueueHandle_t;
#                                     xTicksToWait: TickType_t) {.
#     importcpp: "vQueueWaitForMessageRestricted(@)", header: qheader.}
#   ##  PRIVILEGED_FUNCTION
# proc xQueueGenericReset*(xQueue: QueueHandle_t; xNewQueue: BaseType_t): BaseType_t {.
#     cdecl, importcpp: "xQueueGenericReset(@)", header: qheader.}
#   ##  PRIVILEGED_FUNCTION
# proc vQueueSetQueueNumber*(xQueue: QueueHandle_t; uxQueueNumber: UBaseType_t) {.
#     cdecl, importcpp: "vQueueSetQueueNumber(@)", header: qheader.}
#   ##  PRIVILEGED_FUNCTION
# proc uxQueueGetQueueNumber*(xQueue: QueueHandle_t): UBaseType_t {.
#     importcpp: "uxQueueGetQueueNumber(@)", header: qheader.}
#   ##  PRIVILEGED_FUNCTION
# proc ucQueueGetQueueType*(xQueue: QueueHandle_t): uint8 {.
#     importcpp: "ucQueueGetQueueType(@)", header: qheader.}
#   ##  PRIVILEGED_FUNCTION
# ## * @endcond
