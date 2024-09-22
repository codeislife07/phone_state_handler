package it.mainella.phone_state.handler

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import it.mainella.phone_state.receiver.PhoneStateHandlerReceiver
import it.mainella.phone_state.utils.Constants

class FlutterHandler(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    private var PhoneStateHandlerEventChannel: EventChannel = EventChannel(binding.binaryMessenger, Constants.EVENT_CHANNEL)

    init {
        PhoneStateHandlerEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            private lateinit var receiver: PhoneStateHandlerReceiver

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                receiver = object : PhoneStateHandlerReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        super.onReceive(context, intent)
                        events?.success(
                            mapOf(
                                "status" to status.name,
                                "phoneNumber" to phoneNumber
                            )
                        )
                    }
                }

                binding.applicationContext.registerReceiver(
                    receiver,
                    IntentFilter(TelephonyManager.ACTION_PHONE_STATE_CHANGED)
                )
            }

            override fun onCancel(arguments: Any?) {
                binding.applicationContext.unregisterReceiver(receiver)
            }
        })
    }

    fun dispose() {
        PhoneStateHandlerEventChannel.setStreamHandler(null)
    }
}