package it.mainella.phone_state.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import it.mainella.phone_state.utils.PhoneStateHandlerStatus

open class PhoneStateHandlerReceiver : BroadcastReceiver() {
    var status: PhoneStateHandlerStatus = PhoneStateHandlerStatus.NOTHING;
    var phoneNumber: String? = null;
    override fun onReceive(context: Context?, intent: Intent?) {
        try {
            status = when (intent?.getStringExtra(TelephonyManager.EXTRA_STATE)) {
                TelephonyManager.EXTRA_STATE_RINGING -> PhoneStateHandlerStatus.CALL_INCOMING
                TelephonyManager.EXTRA_STATE_OFFHOOK -> PhoneStateHandlerStatus.CALL_STARTED
                TelephonyManager.EXTRA_STATE_IDLE -> PhoneStateHandlerStatus.CALL_ENDED
                else -> PhoneStateHandlerStatus.NOTHING
            }

            phoneNumber = intent?.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}