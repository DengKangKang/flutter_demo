package com.kk.flutterapp

import android.app.AlertDialog
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.Settings
import android.support.annotation.RequiresApi
import android.support.v4.app.NotificationCompat
import android.support.v4.content.FileProvider
import android.util.Log
import android.widget.Toast
import com.google.gson.Gson
import com.liulishuo.filedownloader.BaseDownloadTask
import com.liulishuo.filedownloader.FileDownloadListener
import com.liulishuo.filedownloader.FileDownloader
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.schedulers.Schedulers
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.File
import java.io.FileInputStream
import java.lang.Exception
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity : FlutterActivity() {

    companion object {
        const val UPDATE_CHANNEL: String = "update_channel"

        const val ACTIVITY_REQUEST_CODE_INSTALL: Int = 1
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        FileDownloader.setup(this)
    }

    override fun onResume() {
        super.onResume()
        checkUpdatePermission()
    }

    private fun checkUpdatePermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (packageManager.canRequestPackageInstalls()) {
                checkUpdate()
            } else {
                android.app.AlertDialog.Builder(this)
                        .setTitle("提示")
                        .setMessage("APP更新需要打开未知来源权限，请去设置中开启权限")
                        .setPositiveButton("确定") { _, _ ->
                            startInstallPermissionSettingActivity()
                        }
                        .setNegativeButton("取消") { _, _ ->
                        }
                        .create()
                        .show()
            }
        } else {
            checkUpdate()
        }
    }

    private fun checkUpdate() {
        val client = OkHttpClient()
        Schedulers.io()
                .createWorker()
                .schedule {
                   try {
                       val request = Request.Builder()
                               .url("http://op.deallinker.com/op/app/fc/appupdate")
                               .build()
                       client.newCall(request)
                               .execute()
                               .also { rsp ->
                                   try {
                                       if (rsp.code == 200) {
                                           val gson = Gson()
                                           val rspStr = rsp.body?.string()
                                           Log.e("MainAct","rsp: $rspStr")
                                           val fromJson = gson.fromJson(rspStr, RspCheckUpdate::class.java)
                                           if(fromJson.version_code > BuildConfig.VERSION_CODE){
                                               runOnUiThread {
                                                   val dialog = AlertDialog.Builder(this@MainActivity)
                                                           .setTitle("有新的版本是否更新？")
                                                           .setMessage(fromJson.info)
                                                           .setPositiveButton("确认") { d, _ ->
                                                               d.dismiss()
                                                               updateApp(fromJson)
                                                           }
                                                           .setNegativeButton("取消", null)
                                                           .create()
                                                   dialog.show()
                                               }
                                               updateApp(fromJson)
                                           }
                                       }else{
                                           Log.e("MainAct","update error")
                                       }
                                   } catch (e: Exception) {
                                       e.printStackTrace()
                                       Log.e("MainAct","GSon format error")
                                   }
                               }
                   }catch (e:Exception){
                       e.printStackTrace()
                   }
                }

    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private fun startInstallPermissionSettingActivity() {
        val packageURI = Uri.parse("package:$packageName")
        val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, packageURI)
        startActivityForResult(intent, ACTIVITY_REQUEST_CODE_INSTALL)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == RESULT_OK && requestCode == ACTIVITY_REQUEST_CODE_INSTALL) {
            checkUpdate()
        }
    }

    val mNotificationId = 0
    val mBuilder = NotificationCompat.Builder(this@MainActivity, UPDATE_CHANNEL)
    var mNotificationManager: NotificationManager? = null


    private fun updateApp(rspCheckUpdate: RspCheckUpdate) {
        Log.e("MainAct","updateApp")
        FileDownloader.getImpl().create(rspCheckUpdate.url)
                .setPath(
                        getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS).absolutePath
                                + File.separator +
                                "${BuildConfig.VERSION_CODE}fee.apk"
                )
                .setForceReDownload(true)
                .setListener(object : FileDownloadListener() {
                    override fun pending(task: BaseDownloadTask, soFarBytes: Int, totalBytes: Int) {}

                    override fun connected(task: BaseDownloadTask?, etag: String?, isContinue: Boolean, soFarBytes: Int, totalBytes: Int) {}

                    override fun progress(task: BaseDownloadTask, soFarBytes: Int, totalBytes: Int) {
                        if (mNotificationManager == null) {
                            mNotificationManager = applicationContext
                                    .getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            val importance = NotificationManager.IMPORTANCE_LOW
                            var channel: NotificationChannel? = mNotificationManager!!
                                    .getNotificationChannel(UPDATE_CHANNEL)
                            if (channel == null) {
                                channel = NotificationChannel(UPDATE_CHANNEL, UPDATE_CHANNEL, importance)
                                mNotificationManager!!.createNotificationChannel(channel)
                            }

                        }

                        mBuilder.setSmallIcon(R.mipmap.ic_launcher)
                                .setContentText("${soFarBytes / 1024 / 1024}Mb/${totalBytes / 1024 / 1024}Mb")
                        if (soFarBytes == totalBytes) {
                            mBuilder.setContentTitle("已完成")
                        } else {
                            mBuilder.setContentTitle("更行进度")
                        }
                        mNotificationManager!!.notify(mNotificationId, mBuilder.build())
                    }

                    override fun blockComplete(task: BaseDownloadTask?) {}

                    override fun retry(task: BaseDownloadTask?, ex: Throwable?, retryingTimes: Int, soFarBytes: Int) {}

                    override fun completed(task: BaseDownloadTask) {
                        val file = File(task.path)
                        //加密后的字符串
                        val input = FileInputStream(file)
                        val byteArray = ByteArray(input.available())
                        input.read(byteArray)
                        if (getMd5Value(byteArray) == rspCheckUpdate.md5) {
                            val intent = Intent()
                            intent.action = "android.intent.action.VIEW"
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
                                val contentUri = FileProvider.getUriForFile(
                                        applicationContext,
                                        BuildConfig.APPLICATION_ID + ".provider",
                                        File(task.path)
                                )
                                intent.setDataAndType(contentUri, "application/vnd.android.package-archive")
                            } else {
                                intent.setDataAndType(Uri.fromFile(File(task.path)),
                                        "application/vnd.android.package-archive")
                            }
                            intent.addCategory("android.intent.category.DEFAULT")
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                        } else {
                            Toast.makeText(this@MainActivity, "更新失败", Toast.LENGTH_LONG).show();
                        }
                    }

                    override fun paused(task: BaseDownloadTask, soFarBytes: Int, totalBytes: Int) {}

                    override fun error(task: BaseDownloadTask, e: Throwable) {
                        Toast.makeText(this@MainActivity, "更新失败", Toast.LENGTH_LONG).show();

                        e.printStackTrace()
                    }

                    override fun warn(task: BaseDownloadTask) {}
                }).start()
    }

    private fun getMd5Value(sSecret: ByteArray): String {
        try {
            val bmd5 = MessageDigest.getInstance("MD5")
            bmd5.update(sSecret)
            var i: Int
            val buf = StringBuilder()
            val b = bmd5.digest()// 加密
            for (aB in b) {
                i = aB.toInt()
                if (i < 0)
                    i += 256
                if (i < 16)
                    buf.append("0")
                buf.append(Integer.toHexString(i))
            }
            return buf.toString()
        } catch (e: NoSuchAlgorithmException) {
            e.printStackTrace()
        }

        return ""
    }


}



