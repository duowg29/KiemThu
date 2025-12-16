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
import com.kms.katalon.core.windows.keyword.WindowsBuiltinKeywords as Windows
import internal.GlobalVariable as GlobalVariable
import org.openqa.selenium.Keys as Keys

WebUI.openBrowser('')

WebUI.navigateToUrl('http://localhost/CAMNEST/')

WebUI.maximizeWindow()

WebUI.click(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (24)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (15)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (15)'), 'tzH6RvlfSTg=')

WebUI.click(findTestObject('Object Repository/Page_CamNest/button_submit (14)'))

WebUI.click(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a_Order_nav-link (1)'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/select_Template_template_type'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/input_Subject_subject'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/input_Send Date and Time_send_date_time'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/input_Target_target'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/input_Target_all'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/textarea_Content_content'))

WebUI.takeScreenshotAsCheckpoint('email_form_input')

WebUI.closeBrowser()

