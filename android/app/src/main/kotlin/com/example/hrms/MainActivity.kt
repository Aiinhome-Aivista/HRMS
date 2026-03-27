package com.example.hrms

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.ObjectAnimator
import android.app.Dialog
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.WindowManager
import android.widget.FrameLayout
import com.google.firebase.inappmessaging.FirebaseInAppMessaging
import com.google.firebase.inappmessaging.model.InAppMessage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import kotlin.random.Random

class MainActivity : FlutterActivity() {

    private var confettiDialog: Dialog? = null
    private var isConfettiShowing = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        FirebaseInAppMessaging.getInstance().addImpressionListener { _: InAppMessage ->
            runOnUiThread {
                showNativeConfetti()
            }
        }

        FirebaseInAppMessaging.getInstance().addDismissListener { _: InAppMessage ->
            runOnUiThread {
                hideNativeConfetti()
            }
        }

        FirebaseInAppMessaging.getInstance().addClickListener { _, _ ->
            // optional
        }

        FirebaseInAppMessaging.getInstance().addDisplayErrorListener { _, _ ->
            runOnUiThread {
                hideNativeConfetti()
            }
        }
    }

    private fun showNativeConfetti() {
        if (isFinishing || isDestroyed) return

        hideNativeConfetti()

        val dialog = Dialog(this, android.R.style.Theme_Translucent_NoTitleBar_Fullscreen)
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)

        val root = FrameLayout(this).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            setBackgroundColor(Color.TRANSPARENT)
            isClickable = false
            isFocusable = false
        }

        dialog.setContentView(root)

        dialog.window?.apply {
            setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
            addFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL)
            addFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE)
            setLayout(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT
            )
            setGravity(Gravity.TOP)
        }

        confettiDialog = dialog
        isConfettiShowing = true
        dialog.show()

        startConfettiBurst(root)

        root.postDelayed({
            hideNativeConfetti()
        }, 2200L)
    }

    private fun hideNativeConfetti() {
        isConfettiShowing = false
        confettiDialog?.dismiss()
        confettiDialog = null
    }

    private fun startConfettiBurst(container: FrameLayout) {
        val screenWidth = resources.displayMetrics.widthPixels
        val screenHeight = resources.displayMetrics.heightPixels

        repeat(40) { index ->
            val piece = View(this).apply {
                val colors = listOf(
                    Color.parseColor("#FFD54F"),
                    Color.parseColor("#EF5350"),
                    Color.parseColor("#42A5F5"),
                    Color.parseColor("#66BB6A"),
                    Color.parseColor("#AB47BC"),
                    Color.parseColor("#FF7043")
                )
                setBackgroundColor(colors.random())

                val sizeDp = Random.nextInt(6, 12)
                val sizePx = dp(sizeDp)

                layoutParams = FrameLayout.LayoutParams(sizePx, sizePx).apply {
                    leftMargin = Random.nextInt(0, screenWidth)
                    topMargin = -Random.nextInt(dp(8), dp(40))
                }

                rotation = Random.nextInt(0, 360).toFloat()
                alpha = 0f
            }

            container.addView(piece)

            val fadeIn = ObjectAnimator.ofFloat(piece, View.ALPHA, 0f, 1f).apply {
                duration = 120L
                startDelay = (index * 12L)
            }

            val fallDistance = Random.nextInt(screenHeight / 3, (screenHeight * 3) / 4)
            val fall = ObjectAnimator.ofFloat(piece, View.TRANSLATION_Y, 0f, fallDistance.toFloat()).apply {
                duration = Random.nextLong(1200L, 1900L)
                startDelay = (index * 12L)
            }

            val drift = ObjectAnimator.ofFloat(
                piece,
                View.TRANSLATION_X,
                0f,
                Random.nextInt(-dp(80), dp(80)).toFloat()
            ).apply {
                duration = fall.duration
                startDelay = fall.startDelay
            }

            val spin = ObjectAnimator.ofFloat(
                piece,
                View.ROTATION,
                piece.rotation,
                piece.rotation + Random.nextInt(180, 720)
            ).apply {
                duration = fall.duration
                startDelay = fall.startDelay
            }

            val fadeOut = ObjectAnimator.ofFloat(piece, View.ALPHA, 1f, 0f).apply {
                duration = 250L
                startDelay = fall.startDelay + fall.duration - 250L
            }

            fadeOut.addListener(object : AnimatorListenerAdapter() {
                override fun onAnimationEnd(animation: Animator) {
                    container.removeView(piece)
                }
            })

            fadeIn.start()
            fall.start()
            drift.start()
            spin.start()
            fadeOut.start()
        }
    }

    private fun dp(value: Int): Int {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value.toFloat(),
            resources.displayMetrics
        ).toInt()
    }

    override fun onDestroy() {
        hideNativeConfetti()
        super.onDestroy()
    }
}