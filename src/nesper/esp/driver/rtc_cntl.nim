##  Copyright 2016-2017 Espressif Systems (Shanghai) PTE LTD
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

import
  esp_err, esp_intr_alloc

## *
##  @brief Register a handler for specific RTC_CNTL interrupts
##
##  Multiple handlers can be registered using this function. Whenever an
##  RTC interrupt happens, all handlers with matching rtc_intr_mask values
##  will be called.
##
##  @param handler  handler function to call
##  @param handler_arg  argument to be passed to the handler
##  @param rtc_intr_mask  combination of RTC_CNTL_*_INT_ENA bits indicating the
##                        sources to call the handler for
##  @return
##       - ESP_OK on success
##       - ESP_ERR_NO_MEM not enough memory to allocate handler structure
##       - other errors returned by esp_intr_alloc
##

proc rtc_isr_register*(handler: intr_handler_t; handler_arg: pointer;
                      rtc_intr_mask: uint32): esp_err_t {.
    importc: "rtc_isr_register", header: "rtc_cntl.h".}
## *
##  @brief Deregister the handler previously registered using rtc_isr_register
##  @param handler  handler function to call (as passed to rtc_isr_register)
##  @param handler_arg  argument of the handler (as passed to rtc_isr_register)
##  @return
##       - ESP_OK on success
##       - ESP_ERR_INVALID_STATE if a handler matching both handler and
##         handler_arg isn't registered
##

proc rtc_isr_deregister*(handler: intr_handler_t; handler_arg: pointer): esp_err_t {.
    importc: "rtc_isr_deregister", header: "rtc_cntl.h".}