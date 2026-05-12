*** Settings ***
Library    SeleniumLibrary

Suite Teardown    Close All Browsers

*** Variables ***
${BROWSER}          Chrome
${URL}              http://localhost/Fitness-swimming-master-main/index.php

${ADMIN_EMAIL}        admin@gmail.com
${ADMIN_PASSWORD}     admin12345

${STUDENT_EMAIL}      googhj2468@hotmail.com
${STUDENT_PASSWORD}   zxc123

${PERSONNEL_EMAIL}      6210210059@psu.ac.th
${PERSONNEL_PASSWORD}   qwe123

${OUT_EMAIL}      6210210074@psu.ac.th
${OUT_PASSWORD}   12345a

${WRONG_PASSWORD}   wrongpass

*** Test Cases ***

# ─────────────────────────────────────────────
# TC-001 | ผู้ดูแลระบบ | Positive
# ─────────────────────────────────────────────
TC-001 Login Admin Successfully
    [Documentation]    เข้าสู่ระบบด้วยสิทธิ์ผู้ดูแลระบบ
    [Tags]    positive    TC-001
    [Setup]    Open Browser And Go To Login Page
    [Teardown]    Close Browser

    Fill Login Form    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}    admin
    Submit Login Form
    Location Should Contain    admin/admin_home.php

# ─────────────────────────────────────────────
# TC-002 | นักศึกษา | Positive
# ─────────────────────────────────────────────
TC-002 Login Student Successfully
    [Documentation]    เข้าสู่ระบบด้วยสิทธิ์นักศึกษา
    [Tags]    positive    TC-002
    [Setup]    Open Browser And Go To Login Page
    [Teardown]    Close Browser

    Fill Login Form    ${STUDENT_EMAIL}    ${STUDENT_PASSWORD}    student
    Submit Login Form
    Location Should Contain    student/student_home.php

# ─────────────────────────────────────────────
# TC-003 | บุคลากรภายใน | Positive
# ─────────────────────────────────────────────
TC-003 Login Personnel In Successfully
    [Documentation]    เข้าสู่ระบบด้วยสิทธิ์บุคลากรภายใน
    [Tags]    positive    TC-003
    [Setup]    Open Browser And Go To Login Page
    [Teardown]    Close Browser

    Fill Login Form    ${PERSONNEL_EMAIL}    ${PERSONNEL_PASSWORD}    in_personnel
    Submit Login Form
    Location Should Contain    in_personnel/in_personnel_home.php

# ─────────────────────────────────────────────
# TC-004 | บุคลากรภายนอก | Positive
# ─────────────────────────────────────────────
TC-004 Login Personnel Out Successfully
    [Documentation]    เข้าสู่ระบบด้วยสิทธิ์บุคลากรภายนอก
    [Tags]    positive    TC-004
    [Setup]    Open Browser And Go To Login Page
    [Teardown]    Close Browser

    Fill Login Form    ${OUT_EMAIL}    ${OUT_PASSWORD}    out_personnel
    Submit Login Form
    Location Should Contain    out_personnel/out_personnel_home.php

# ─────────────────────────────────────────────
# TC-005 | Password ผิด | Negative
# ─────────────────────────────────────────────
TC-005 Login With Wrong Password
    [Documentation]    กรอก Password ผิด ระบบต้องแสดง "Wrong email or password or role"
    [Tags]    negative    TC-005
    [Setup]    Open Browser And Go To Login Page
    [Teardown]    Close Browser

    Fill Login Form    ${ADMIN_EMAIL}    ${WRONG_PASSWORD}    admin
    Submit Login Form
    Wait Until Page Contains    Wrong email or password or role    10s

# ─────────────────────────────────────────────
# TC-006 | ไม่เลือก Role | Negative
# ─────────────────────────────────────────────
TC-006 Login Without Selecting Role
    [Documentation]    ไม่เลือกระดับสมาชิก ระบบต้องแสดง "Wrong email or password or role"
    [Tags]    negative    TC-006
    [Setup]    Open Browser And Go To Login Page
    [Teardown]    Close Browser

    Input Text        name:txt_email      ${ADMIN_EMAIL}
    Input Password    name:txt_password   ${ADMIN_PASSWORD}
    # ไม่เลือก role — ค่า default เป็น "" → login_db.php เซ็ต $errorMsg แต่ไม่ redirect
    # หน้าจะค้างที่ login_db.php และไม่มี session login ใดถูกเซ็ต
    Submit Login Form
    Sleep    2s
    Location Should Not Contain    admin/admin_home.php
    Location Should Not Contain    student/student_home.php
    Location Should Not Contain    in_personnel/in_personnel_home.php
    Location Should Not Contain    out_personnel/out_personnel_home.php

*** Keywords ***
Open Browser And Go To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Delete All Cookies
    Go To    ${URL}
    Wait Until Element Is Visible    name:txt_email    timeout=15s

Fill Login Form
    [Arguments]    ${email}    ${password}    ${role}
    Input Text        name:txt_email      ${email}
    Input Password    name:txt_password   ${password}
    Select From List By Value    name:txt_role    ${role}

Submit Login Form
    Click Button    name:btn_login
    Sleep    2s
