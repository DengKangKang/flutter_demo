package com.kk.flutterapp

/**
 * title: RspDataCount.
 * description:
 * author：DKK
 * Created on 2018/6/8.
 */
data class RspCheckUpdate(var create_time: String,
                          var version_code: Int,
                          var version_name: String,
                          var info: String,
                          var url: String,
                          var md5: String
)