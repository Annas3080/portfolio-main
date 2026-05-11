*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}        Chrome
${URL}            http://localhost/Fitness-swimming-master-main/index.php

${EMAIL}          admin@gmail.com
${PASSWORD}       admin12345

*** Test Cases ***
Login As Admin

    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

    # รอหน้าโหลด
    Wait Until Element Is Visible    name:txt_email    10s

    # กรอก Email
    Input Text    name:txt_email    ${EMAIL}

    # กรอก Password
    Input Password    name:txt_password    ${PASSWORD}

    # เลือก role = ระดับ
    Select From List By Value    name:txt_role    admin

    Sleep    2s

    # กดปุ่ม Login
    Click Button    name:btn_login

    Sleep    5s

    Close Browser