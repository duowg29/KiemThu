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

WebUI.click(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (44)'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/label_Or_toggleLabel (9)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Sign Up_txt-signup (5)'), 'phu1234@')

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Sign Up_email (5)'), 'quachnk63@gmail.com')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Sign Up_signupPassword1 (5)'), '+N2vD+nn6r0qcSVVRBuo0A==')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input__signupPassword2 (5)'), 'zfXPHq+hYj8=')

WebUI.click(findTestObject('Object Repository/Page_CamNest/input__acceptEULA (4)'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/button_Subscribe for news_signupButton (5)'))

WebUI.click(findTestObject('Object Repository/Page_CamNest/div_Or_alert-danger (1)'))

WebUI.takeScreenshotAsCheckpoint('T14-01')

WebUI.closeBrowser()

