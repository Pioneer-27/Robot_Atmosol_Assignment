*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Collections
Library           JSONLibrary

*** Keywords ***
Initialize Portal
    [Arguments]    ${url}    ${driver}
    [Documentation]    Open Browser And Login with User Name and Password
    Open Browser    ${url}    ${driver}
    Maximize Browser Window
    Sleep    2

Login To Portal
    [Arguments]    ${usrname}    ${password}
    Wait Until Element Is Visible    //*[@id='user-name']
    Input Text    //*[@id='user-name']    ${usrname}
    Wait Until Element Is Visible    //*[@id='password']
    Sleep    2
    Input Text    //*[@id='password']    ${password}
    Wait Until Element Is Visible    //*[@id='login-button']
    Sleep    2
    Click Button    //*[@id='login-button']
    Sleep    3

Select Menu
    [Arguments]    ${menu}
    Element Should Be Visible    //*[@id='react-burger-menu-btn']
    Click Element    //*[@id='react-burger-menu-btn']
    Wait Until Element Is Visible    //*[@class='bm-item-list']//ancestor::*[@class='bm-menu-wrap']//*[text()='${menu}']
    Click Element    //*[@class='bm-item-list']//ancestor::*[@class='bm-menu-wrap']//*[text()='${menu}']
    Sleep    2

Verify Page Location
    [Arguments]    ${exp_location}
    Wait Until Location Is    ${exp_location}    100
    ${act_location}=    Log Location
    Should Be Equal    ${exp_location}    ${act_location}
    Location Should Be    ${exp_location}

Validate Total Cost
    Scroll Element Into View    //*[@class='summary_info_label summary_total_label']
    ${total_price} =    Get Text    //*[@class='summary_info_label summary_total_label']
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
