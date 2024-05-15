*** Settings ***
Suite Setup       Initialize Portal    ${login_url}    ${driver}
Suite Teardown    Close Browser
Library           SeleniumLibrary
Library           String
Library           Collections
Library           RequestsLibrary
Variables         ../testdata/user_testdata.yaml
Variables         ../../src_main/testdata/main_testdata.yml
Resource          ../../src_main/resources/commonkeyword.robot
Variables         ../../src_main/testdata/portalcommon_testdata.yml
Resource          ../resources/user_comnkeyword.robot

*** Test Cases ***
OpenAndLogin
    [Documentation]    Open Browser And Login with User Name and Password
    [Setup]    Login To Portal    ${login_usrid}    ${login_password}
    Wait Until Element Is Visible    //*[contains(text(),'${home_title}')]//ancestor::*[@class='app_logo']
    Element Text Should Be    //*[contains(text(),'${home_title}')]//ancestor::*[@class='app_logo']    ${home_title}

Open_Menu
    [Documentation]    Open Menu, Go To About Page, Validate url. Go back to product page and pick the item with Highest Value
    Select Menu    ${about}
    Verify Page Location    ${home_url}
    Go Back
    Verify Page Location    ${inventory_url}
    Sort Items    ${hilo}

Add Item To Cart
    [Documentation]    Add item with higest value into cart
    Select Item With Highest Price
    Sleep    2
    Wait Until Element Is Visible    //*[@class='inventory_item_container']//*[normalize-space()='Sauce Labs Fleece Jacket']
    Click Element    //div[@class='inventory_details_name large_size']//ancestor::*[@class="inventory_details"]//*[contains(@class,'btn_primary')]
    Sleep    3

Checkout via Cart
    [Documentation]    Go to Checkout page & verify location
    Wait Until Element Is Visible    //*[@class='shopping_cart_link']
    Click Element    //*[@class='shopping_cart_link']
    Sleep    3
    Wait Until Location Contains    https://www.saucedemo.com/cart.html
    Log Location
    Element Should Be Visible    //*[@id='checkout']
    Click Button    //*[@id='checkout']
    Wait Until Location Contains    https://www.saucedemo.com/checkout-step-one.html
    Page Should Contain    Checkout: Your Information

CartInfo
    [Documentation]    Fill the necessary info on checkout page
    Page Should Contain Element    //*[@id='first-name']
    Input Text    //*[@id='first-name']    ${first_name}
    Wait Until Element Is Visible    //*[@id='last-name']
    Input Text    //*[@id='last-name']    ${lst_name}
    Wait Until Element Is Visible    //*[@id='postal-code']
    Input Text    //*[@id='postal-code']    ${zip_code}
    Wait Until Element Is Visible    //*[@id='continue']    50
    Sleep    3
    Click Button    //*[@id='continue']

Validate Total Value
    [Documentation]    Go to Overview Summary page and Validate the total price in the format as $xx.yy
    Wait Until Location Contains    https://www.saucedemo.com/checkout-step-two.html
    Page Should Contain    Checkout: Overview
    Scroll Element Into View    //*[@class='summary_total_label']
    ${total_price} =    Get Text    //*[@class='summary_total_label']
    @{values} =    Split String    ${total_price}    ${SPACE}
    ${first_value} =    Set Variable    ${values}[0]
    ${second_value} =    Set Variable    ${values}[1]
    Log    ${second_value}
    ${total_price}=    Set Variable    ${second_value}
    ${price_list}=    Evaluate    list("${total_price}")
    Log To Console    Price List: ${price_list}
    # Validate Price List
    Log    ${price_list.__len__()}
    Should Be Equal As Numbers    ${price_list.__len__()}    6    msg=List should contain 6 characters
    Should Match Regexp    ${price_list[3]}    \.    msg=Third character should be '.'
    Should Be Equal As Strings    ${price_list[0]}    $    msg=First character should be '$'
    Log To Console    Total Price Matches the Format $xx.yy.
    sleep    5

*** Keywords ***
Select Item With Highest Price
    ${price_elements}    Get WebElements    ${price_xpath}    # Adjust the XPath according to the website structure
    ${all_prices}    Create List    # Create an empty list to store all prices
    ${itemprices}    Create List
    FOR    ${price_element}    IN    @{price_elements}
        ${price_text}    Get Text    ${price_element}
        Append To List    ${itemprices}    ${price_text}
        #${price_value}    Set Variable    ${price_text.replace('$', '').replace(',', '')}
        #${price_value}    Convert To Number    ${price_value}
        #Append To List    ${all_prices}    ${price_value}    # Append each price to the list
    END
    Log To Console    ${itemprices}
    ${original_order}=    Copy list    ${itemprices}    #returns original order
    Log To Console    ${original_order}
    Log To Console    ${original_order}[0]
    ${highestvalue_item}    Get Text    ${highcost}
    Sleep    2
    Run Keyword If    '${highestvalue_item}' == '${original_order}[0]'    Click Element    ${highcost_itemtitle}
