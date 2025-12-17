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

WebUI.maximizeWindow()

ExtendedKeywords.safeClickLoginIcon(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (13)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (4)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (4)'), 'tzH6RvlfSTg=')

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/button_suExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a__nav-ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Account Management - CamNest/input_Account Status_searchInput'))_Account Status_searchInput'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Account Management - CamNest/select_Account Status_statExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Account Management - CamNest/select_Account StatuExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Account Management - CamNest/button_Account Status_btn btn-primary'))ount Status_btn btn-primary'))

WebUI.takeScreenshotAsCheckpoint('account_mana_list')

WebUI.closeBrowser()

