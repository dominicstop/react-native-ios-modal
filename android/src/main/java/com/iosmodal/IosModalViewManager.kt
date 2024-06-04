package com.iosmodal

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.IosModalViewManagerInterface
import com.facebook.react.viewmanagers.IosModalViewManagerDelegate

@ReactModule(name = IosModalViewManager.NAME)
class IosModalViewManager : SimpleViewManager<IosModalView>(),
  IosModalViewManagerInterface<IosModalView> {
  private val mDelegate: ViewManagerDelegate<IosModalView>

  init {
    mDelegate = IosModalViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<IosModalView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): IosModalView {
    return IosModalView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: IosModalView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "IosModalView"
  }
}
