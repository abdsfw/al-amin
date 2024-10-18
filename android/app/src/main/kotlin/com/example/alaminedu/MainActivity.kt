// package com.example.alaminedu

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity() {
// }

 package com.example.alaminedu
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method
import java.net.NetworkInterface
import java.util.*
import android.view.WindowManager.LayoutParams
class MainActivity: FlutterActivity() {

    private  val CHANNEL = "com.example.alaminedu";

    private  lateinit var channel: MethodChannel
    //? for privacy of take screen shout or recording vidue
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL)
    }
    //? ----------------------------------------------------

//    private fun isDeviceRooted(): Boolean {
//        val buildTags = Build.TAGS
//        if (buildTags != null && buildTags.contains("test-keys")) {
//            return true
//        }
//
//        // Check for common root binaries
//        val paths = arrayOf(
//            "/system/app/Superuser.apk",
//            "/sbin/su",
//            "/system/bin/su",
//            "/system/xbin/su",
//            "/data/local/xbin/su",
//            "/data/local/bin/su",
//            "/system/sd/xbin/su",
//            "/system/bin/failsafe/su",
//            "/data/local/su"
//        )
//
//        for (path in paths) {
//            if (File(path).exists()) {
//                return true
//            }
//        }
//
//        return false
//    }
}