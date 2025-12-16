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

WebUI.click(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (76)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (58)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (58)'), 'tzH6RvlfSTg=')

WebUI.click(findTestObject('Object Repository/Page_CamNest/button_submit (57)'))

WebUI.click(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a_Account_nav-link (14)'))

WebUI.click(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/button_So snh s lng sn phm theo nh cung cp__46b4ec (1)'))

WebUI.setText(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/input__productName'), 'Flash Nikon ')

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/select__categorySelect'), 
    '2', true)

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/select__supplierSelect'), 
    '3', true)

WebUI.setText(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/input__productPrice'), '16000000')

WebUI.setText(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/textarea_Description_productDescription'), 
    'mô tả về flash')

WebUI.click(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/button_Cancel_btn btn-primary'))

WebUI.takeScreenshotAsCheckpoint('T28-01')

WebUI.closeBrowser()

