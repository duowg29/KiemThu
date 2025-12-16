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

WebUI.click(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (89)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (71)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (71)'), 'tzH6RvlfSTg=')

WebUI.click(findTestObject('Object Repository/Page_CamNest/button_submit (70)'))

WebUI.click(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a_Order_nav-link (7)'))

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_CamNest/select_Template_template_type (1)'), 'Promotional_Custom', 
    true)

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Subject_subject (1)'), 'Khuyến mãi đặc biệt')

WebUI.click(findTestObject('Object Repository/Page_CamNest/input_Target_all (1)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/textarea_Content_content (1)'), 'Nội dung khuyến mãi')

WebUI.takeScreenshotAsCheckpoint('T40-01')

WebUI.closeBrowser()

