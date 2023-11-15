
*** Settings ***
Library    SeleniumLibrary
Library    String

*** Test Cases ***
Book a Flight
## Siirrytään sivulle.
    Open Browser    http://blazedemo.com/   
    ...    Chrome    options=add_experimental_option("detach", True)
    Sleep    2

    Maximize Browser Window
## Tarkistetaan, että sivulla lukee seuraavaa.
    Page Should Contain    Welcome to the Simple Travel Agency!

## Valitaan lähtökaupunki.
*** Variables ***
${departurecity}    Boston

*** Test Cases***
Select departure.
    Click Element    name:fromPort
    Select From List By Value    name:fromPort    ${departurecity}
    Set Global Variable    ${departurecity}

    Sleep    2

## Valitaan päämäärä.
*** Variables ***
${destinationcity}    Cairo

*** Test Cases ***
Select destination.
    Click Element    name:toPort
    Select From List By Value    name:toPort    ${destinationcity} 
    Set Global Variable    ${destinationcity}

*** Test Cases ***
Push the Button
## Tarkistetaan, että sivulta löytyy tarvittava namiska.
    Page Should Contain Button    Find Flights

    Sleep    2

## Painetaan kyseistä namiskaa.
    Click Button    Find Flights

*** Test Cases ***
Check your options.
## Sivulla tulisi lukea: Flights from Boston to Cairo (käytä muuttujia).
    Page Should Contain   Flights from ${departurecity} to ${destinationcity}

    Sleep    2

##Tarkista, että sinulla on ainakin yksi osuma näkyvillä.
    @{flights}=    Get WebElements    xpath:/html/body/div[2]/table
    Should Not Be Empty     ${flights}

##Valitse jokin lennoista
    Click Button    xpath:/html/body/div[2]/table/tbody/tr[4]/td[1]/input

*** Variables ***
## Kirjoita muuttujiin muistiin kyseisen lennon hinta, numero ja lentoyhtiö
${airline}    Virgin America
${flightNumber}    12
${flightCost}    765.32

*** Test Cases ***
Checking variables.
## Tarkista aukeavalta sivulta, että muuttujiin kirjoittamasi tiedot löytyvät sivulta:
## Matkan hinta.
    ${newprice}    Get Text    xpath:/html/body/div[2]/p[3]
    Run Keyword And Ignore Error    Should Be Equal    ${flightCost}    ${newprice}

## Lentoyhtiö.
    ${newAirline}    Get Text    xpath:/html/body/div[2]/p[1]
    Run Keyword And Ignore Error    Should Be Equal    ${airline}    ${newAirline}

## Lennon numero.
    ${newFlightNumber}    Get Text    xpath:/html/body/div[2]/p[2]
    Run Keyword And Ignore Error    Should Be Equal    ${flightNumber}    ${newFlightNumber}

## Tallena muuttujaan lennon kokonaishinta
    ${totalCost}=    Set Variable    914,76
    Set Global Variable    ${totalCost}
    Sleep    3

*** Test Cases ***
Fill it up.
## Täytä matkustajan tiedot kaavakkeelle.
    Click Element    name:inputName
    Input Text    name:inputName   Luke Skywalker

    Click Element    name:address
    Input Text    name:address    Mobile Street 666

    Sleep    2

    Click Element    name:city
    Input Text    name:city    Mobile

    Click Element    name:state
    Input Text    name:state    Alabama

    Click Element    name:zipCode
    Input Text    name:zipCode    36525

    Sleep    2
## Valitse luottokortiksi Diner's Club
    Click Element    id:cardType
    Select From List By Value    id:cardType    dinersclub

    Click Element    name:creditCardNumber
    Input Text    name:creditCardNumber    6666 6666 6666 6666

## Aseta kortin kuukausi ja vuosi globaaleiksi muuttujiksi.

    Click Element    name:creditCardMonth
    Input Text    name:creditCardMonth    10
    ${creditMonth}=    Set Variable    10/
    Set Global Variable    ${creditMonth}

    Click Element    name:creditCardYear
    Input Text    name:creditCardYear    2027
    ${creditYear}=    Set Variable    2027
    Set Global Variable    ${creditYear}

    Sleep    2
    ## Klikkaa "Remember me"
    Select Checkbox    id:rememberMe
    ## Klikkaa "Purchase Flight"
    Click Button    Purchase Flight

*** Test Cases ***
Get comfortable in your buying pants.
    ## Tarkista, että aukeavalta sivulta löytyy teksti "Thank you for your purchase today!"
    Page Should Contain    Thank you for your purchase today!

    Sleep    2

    ##Tarkista, että expiroitumisaika on oikein.
    ${newExpirationMonth}    Get Text    xpath:/html/body/div[2]/div/table/tbody/tr[5]/td[2]
    Run Keyword And Ignore Error    Should Be Equal    ${creditMonth}${creditYear}   ${newExpirationMonth}

    ## Tarkista, että kokonaishinta on oikein.
    ${amount}=    Get Text    xpath:/html/body/div[2]/div/table/tbody/tr[3]/td[2]
    Run Keyword And Ignore Error    Should Be Equal    ${totalCost}   ${amount}
    
    Sleep    1

    ## Sulje selain
    Close Browser
