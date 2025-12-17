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

ExtendedKeywords.safeClickLoginIcon(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (75)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (57)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (57)'), 'tzH6RvlfSTg=')

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/button_submit (56)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a_Account_nav-link (13)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/input_So snh s lng sn phm theo nh cung cp_s_6477d0 (4)'))

WebUI.sendKeys(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/input_So snh s lng sn phm theo nh cung cp_s_6477d0 (4)'), 
    Keys.chord(Keys.ENTER))

WebUI.takeScreenshotAsCheckpoint('T27-04')

WebUI.closeBrowser()

