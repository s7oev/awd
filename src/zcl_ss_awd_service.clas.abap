CLASS zcl_ss_awd_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES:
      if_http_service_extension.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF response_s,
        code  TYPE i,
        value TYPE string,
      END OF response_s.

    METHODS:
      create
        IMPORTING request_body  TYPE string
        RETURNING VALUE(result) TYPE response_s,
      read
        RETURNING VALUE(result) TYPE response_s,
      update
        IMPORTING request_body  TYPE string
        RETURNING VALUE(result) TYPE response_s,
      delete
        IMPORTING request_body  TYPE string
        RETURNING VALUE(result) TYPE response_s.
ENDCLASS.



CLASS zcl_ss_awd_service IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.
    DATA(method) = request->get_method( ).

    DATA response_code_and_value TYPE response_s.

    IF method = 'POST'.
      response_code_and_value = create( request->get_text(  ) ).
    ELSEIF method = 'GET'.
      response_code_and_value = read( ).
    ELSEIF method = 'PUT'.
      response_code_and_value = update( request->get_text(  ) ).
    ELSEIF method = 'DELETE'.
      response_code_and_value = delete( request->get_text(  ) ).
    ENDIF.

    response->set_status( response_code_and_value-code ).
    response->set_text( response_code_and_value-value ).
  ENDMETHOD.


  METHOD create.
    DATA html TYPE zss_awd_html.
    xco_cp_json=>data->from_string( request_body )->write_to( REF #( html ) ).

    INSERT zss_awd_html FROM @html.

    IF sy-subrc = 0.
      result-code = 200.
      result-value = xco_cp_json=>data->from_abap( html )->to_string(  ).
    ELSE.
      result-code = 500.
      result-value = 'Page with this name already exists'.
    ENDIF.
  ENDMETHOD.


  METHOD read.
    SELECT *
      FROM zss_awd_html
      INTO TABLE @DATA(html_tab).

    result-code = 200.
    result-value = xco_cp_json=>data->from_abap( html_tab )->to_string(  ).
  ENDMETHOD.


  METHOD update.
    DATA html TYPE zss_awd_html.
    xco_cp_json=>data->from_string( request_body )->write_to( REF #( html ) ).

    UPDATE zss_awd_html FROM @html.

    IF sy-subrc = 0.
      result-code = 200.
      result-value = xco_cp_json=>data->from_abap( html )->to_string(  ).
    ELSE.
      result-code = 500.
      result-value = 'Error in update'.
    ENDIF.
  ENDMETHOD.


  METHOD delete.
    DELETE FROM zss_awd_html
      WHERE page_name = @request_body.

    IF sy-subrc = 0.
      result-code = 200.
    ELSE.
      result-code = 500.
      result-value = 'Error in delete'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
