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

WebUI.click(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (80)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (62)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (62)'), 'tzH6RvlfSTg=')

WebUI.click(findTestObject('Object Repository/Page_CamNest/button_submit (61)'))

WebUI.click(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a_Account_nav-link (18)'))

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/select_So snh s lng sn phm theo nh cung cp__558c02 (1)'), 
    '1', true)

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/select_So snh s lng sn phm theo nh cung cp_sortBy (1)'), 
    'price_asc', true)

WebUI.click(findTestObject('Object Repository/Page_Advanced Product Manager - CamNest/button_Add Product_btn btn-secondary (2)'))

WebUI.takeScreenshotAsCheckpoint('T29-02')

WebUI.closeBrowser()

