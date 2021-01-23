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
      add,
      not_found_404.
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

    path = zcl_ss_awd_helper=>format_path( path ).
    TRY.
        CALL METHOD me->(path).
      CATCH cx_sy_dyn_call_illegal_method.
        not_found_404(  ).
    ENDTRY.
  ENDMETHOD.


  METHOD home.
    response->set_text( zcl_ss_awd_helper=>get_page_html( 'index' ) ).
  ENDMETHOD.


  METHOD browse.
    DATA(movies) = zcl_ss_awd_movies=>read_all(  ).

    DATA(html) = zcl_ss_awd_helper=>render_html(
     html = zcl_ss_awd_helper=>get_page_html( 'browse' ) var_and_content_tab = VALUE #(
     ( variable = 'movies' content = zcl_ss_awd_movies=>itab_to_html_tab( movies ) ) ) ).

    response->set_text( html ).
  ENDMETHOD.


  METHOD add.
    IF request->get_form_field( 'execute' ) = abap_true.
      " add the movie
      DATA(subrc) = zcl_ss_awd_movies=>create( name = request->get_form_field( 'name' )
        year = CONV #( request->get_form_field( 'year' ) ) ).

      " prepare response based on subrc
      DATA(response_title) = SWITCH #( subrc WHEN 0 THEN |Successfully added movie { request->get_form_field( 'name' ) }|
        ELSE |Sorry, we could not add the movie...| ).

      DATA(response_content) = SWITCH #( subrc WHEN 0 THEN |Thank you for extending our movie database!|
        ELSE |...because we already have it in our database!| ).

      " return the dynamically rendered HTML response
      DATA(html) = zcl_ss_awd_helper=>get_page_html( 'executed_add' ).

      html = zcl_ss_awd_helper=>render_html( html = html var_and_content_tab = VALUE #(
        ( variable = 'response_title' content = response_title )
        ( variable = 'response_body'  content = response_content ) ) ).

      response->set_text( html ).
    ELSE.
      response->set_text( zcl_ss_awd_helper=>get_page_html( 'add' ) ).
    ENDIF.
  ENDMETHOD.


  METHOD not_found_404.
    response->set_text( zcl_ss_awd_helper=>get_page_html( '404' ) ).
  ENDMETHOD.
ENDCLASS.
