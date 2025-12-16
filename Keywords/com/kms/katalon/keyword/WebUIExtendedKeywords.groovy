package com.kms.katalon.keyword

import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI

public class WebUIExtendedKeywords {
	
	/**
	 * Mở browser và tự động maximize window
	 * @param url URL để mở (có thể để trống)
	 */
	static def openBrowserAndMaximize(String url = '') {
		WebUI.openBrowser(url)
		try {
			WebUI.maximizeWindow()
		} catch (Exception e) {
			// Nếu không maximize được, đợi một chút rồi thử lại
			Thread.sleep(500)
			try {
				WebUI.maximizeWindow()
			} catch (Exception e2) {
				// Bỏ qua nếu vẫn không được
			}
		}
	}
	
	/**
	 * Navigate đến URL và tự động maximize window
	 * @param url URL để navigate
	 */
	static def navigateToUrlAndMaximize(String url) {
		WebUI.navigateToUrl(url)
		try {
			WebUI.maximizeWindow()
		} catch (Exception e) {
			// Nếu không maximize được, đợi một chút rồi thử lại
			Thread.sleep(500)
			try {
				WebUI.maximizeWindow()
			} catch (Exception e2) {
				// Bỏ qua nếu vẫn không được
			}
		}
	}
}

