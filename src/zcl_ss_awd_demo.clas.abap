CLASS zcl_ss_awd_demo DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES:
      if_http_service_extension.

  PRIVATE SECTION.
    DATA:
      request  TYPE REF TO if_web_http_request,
      response TYPE REF TO if_web_http_response.

    METHODS:
      home,
      browse,
      add.
ENDCLASS.



CLASS zcl_ss_awd_demo IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.
    me->request = request.
    me->response = response.

    DATA(path) = request->get_header_field( '~path_info' ).

    IF strlen( path ) EQ 0.
      home(  ).
      RETURN.
    ENDIF.

    path = zcl_ss_awd_helper=>format_path( request->get_header_field( '~path_info' ) ).
    CALL METHOD me->(path).
  ENDMETHOD.


  METHOD home.
    response->set_text( zcl_ss_awd_helper=>get_page_html( 'index' ) ).
  ENDMETHOD.


  METHOD browse.
    response->set_text( zcl_ss_awd_helper=>get_page_html( 'browse' ) ).
  ENDMETHOD.


  METHOD add.
    IF request->get_form_field( 'execute' ) = abap_true.
      response->set_text( zcl_ss_awd_helper=>get_page_html( 'executed_add' ) ).
    ELSE.
      response->set_text( zcl_ss_awd_helper=>get_page_html( 'add' ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
