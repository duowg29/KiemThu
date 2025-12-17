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

ExtendedKeywords.safeClickLoginIcon(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (122)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (105)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (105)'), 'tzH6RvlfSTg=')

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/button_submit (104)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a_Product_nav-link (21)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Advanced Order Management - CamNest/button_Doanh thu theo phng thc thanh ton_bt_8cb3d1 (2)'))

WebUI.setText(findTestObject('Object Repository/Page_Advanced Order Management - CamNest/input_Khch hng_customer_search (1)'), 
    '')

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_Advanced Order Management - CamNest/select__product_select (1)'), 
    '200', true)

WebUI.takeScreenshotAsCheckpoint('T36-02')

WebUI.closeBrowser()

