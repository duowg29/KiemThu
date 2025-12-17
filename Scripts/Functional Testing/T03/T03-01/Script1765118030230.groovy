import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import static com.kms.katalon.core.testobject.ObjectRepository.findWindowsObject
import com.kms.katalon.core.checkpoint.Checkpoint as Checkpoint
import com.kms.katalon.core.cucumber.keyword.CucumberBuiltinKeywords as CucumberKW
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.testcase.TestCase as TestCase
import com.kms.katalon.core.testdata.TestData as TestData
import com.kms.katalon.core.testng.keyword.TestNGBuiltinKeywords as TestNGKW
import com.kms.katalon.core.testobject.TestObject as TestObject
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.keyword.WebUIExtendedKeywords as ExtendedKeywords
import com.kms.katalon.core.windows.keyword.WindowsBuiltinKeywords as Windows
import internal.GlobalVariable as GlobalVariable
import org.openqa.selenium.Keys as Keys

WebUI.openBrowser('')

WebUI.maximizeWindow()

WebUI.navigateToUrl('http://localhost/CAMNEST/')

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/a (7)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/select_Brand_brand'))

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_CamNest - Camera/select_Brand_brand'), 'Canon', true)

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/select_Price Range_price'))

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_CamNest - Camera/select_Price Range_price'), '20m-40m', 
    true)

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/button_Sort By_search-btn'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/div_Featured Products_product-list'))

WebUI.takeScreenshotAsCheckpoint('T03-01')

WebUI.closeBrowser()

