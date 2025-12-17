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

WebUI.navigateToUrl('http://localhost/CAMNEST/')

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/a (18)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/i_My nh k thut s Sony ZV-E10_far fa-cart-plus cart (4)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/i_Contact_fas fa-shopping-cart (4)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/i_Subtotal_fa-regular fa-circle-xmark'))

WebUI.takeScreenshotAsCheckpoint('T07-02')

WebUI.closeBrowser()

