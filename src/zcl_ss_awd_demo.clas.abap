CLASS zcl_ss_awd_demo DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES:
      if_http_service_extension.

  PRIVATE SECTION.
    METHODS:
      hey
        IMPORTING request  TYPE REF TO if_web_http_request
                  response TYPE REF TO if_web_http_response.
ENDCLASS.



CLASS zcl_ss_awd_demo IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.
    " get the path and remove the last char
    DATA(path_info) = request->get_header_field( '~path_info' ).
    DATA(path_length) = strlen( path_info ) - 1.
    path_info = path_info+1(path_length).

    CALL METHOD me->(path_info)
      EXPORTING request = request
                response = response.
  ENDMETHOD.


  METHOD hey.
    SELECT SINGLE * FROM zss_awd_html WHERE page_name = 'hey' INTO @DATA(html).

    response->set_text( html-content ).
  ENDMETHOD.
ENDCLASS.
