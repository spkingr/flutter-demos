package me.liuqingwen.projectsendscreenshot

import android.content.Intent
import android.net.Uri
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity() : FlutterActivity()
{
    companion object
    {
        private const val CHANNEL = "me.liuqingwen.screenshot"
        private const val METHOD_NAME = "onFlutterTakeSceenshot"
    }
    
    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        
        MethodChannel(this.flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call?.method == METHOD_NAME)
            {
                call.argument<String>("filePath")?.let {
                    this.sendMail(Uri.fromFile(File(it)))
                }
            }
            else
            {
                result.notImplemented()
            }
        }
    }
    
    private fun sendMail(uri: Uri)
    {
        val intent = Intent(Intent.ACTION_SEND).apply {
            this.type = "text/plain"
            this.putExtra(Intent.EXTRA_EMAIL, arrayOf("email@email.com"))
            this.putExtra(Intent.EXTRA_SUBJECT, "Test Flutter Screenshot")
            this.putExtra(Intent.EXTRA_STREAM, uri)
        }
        this.startActivity(intent)
    }
}
