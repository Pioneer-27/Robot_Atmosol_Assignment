*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Collections

*** Keywords ***
Sort Items
    [Arguments]	${sort_order}
    Wait Until Element Is Visible    //*[@class='product_sort_container']    80
    Click Element    //*[@class='product_sort_container']
    Wait Until Element Is Visible    //*[@class="product_sort_container"]//*[contains(text(),'${sort_order}')]
    Click Element    //*[@class="product_sort_container"]//*[contains(text(),'${sort_order}')]
    
    

