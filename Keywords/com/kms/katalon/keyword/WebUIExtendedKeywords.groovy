package com.kms.katalon.keyword

import java.util.Arrays
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.testobject.TestObject
import com.kms.katalon.core.model.FailureHandling

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
	
	/**
	 * Click vào element một cách an toàn với wait, scroll và fallback JavaScript click
	 * Giải quyết vấn đề ElementNotInteractableException trong headless mode
	 * @param testObject TestObject cần click
	 * @param timeout Timeout để đợi element (mặc định 20 giây)
	 * @param failureHandling FailureHandling strategy (mặc định STOP_ON_FAILURE)
	 */
	static def safeClick(TestObject testObject, int timeout = 20, FailureHandling failureHandling = FailureHandling.STOP_ON_FAILURE) {
		try {
			// Đợi element present (tồn tại trong DOM) trước
			WebUI.waitForElementPresent(testObject, timeout, failureHandling)
			
			// Đợi element visible và scroll đến element
			WebUI.waitForElementVisible(testObject, timeout, failureHandling)
			WebUI.scrollToElement(testObject, timeout, failureHandling)
			
			// Thử click bình thường
			WebUI.click(testObject, failureHandling)
		} catch (Exception e) {
			// Fallback: Dùng JavaScript click nếu normal click fail
			println "Normal click failed for ${testObject.getObjectId()}, trying JavaScript click..."
			println "Error: ${e.getMessage()}"
			try {
				def element = WebUI.findWebElement(testObject, timeout)
				WebUI.executeJavaScript('arguments[0].click();', Arrays.asList(element))
			} catch (Exception jsException) {
				println "JavaScript click also failed: ${jsException.getMessage()}"
				throw jsException
			}
		}
	}
	
	/**
	 * Click vào login icon một cách an toàn
	 * Đặc biệt xử lý cho login icon vì đây thường là click đầu tiên sau khi navigate
	 * @param loginIconObject TestObject của login icon
	 * @param timeout Timeout để đợi element (mặc định 20 giây)
	 */
	static def safeClickLoginIcon(TestObject loginIconObject, int timeout = 20) {
		if (loginIconObject == null) {
			throw new IllegalArgumentException("loginIconObject cannot be null. Please provide the TestObject for login icon.")
		}
		
		// Đợi page load hoàn toàn (đặc biệt quan trọng cho click đầu tiên)
		WebUI.delay(2)
		
		// Sử dụng safeClick để click an toàn
		safeClick(loginIconObject, timeout)
	}
}

