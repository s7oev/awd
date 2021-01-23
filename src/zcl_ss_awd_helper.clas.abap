CLASS zcl_ss_awd_helper DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS:
      format_path
        IMPORTING path          TYPE string
        RETURNING VALUE(result) TYPE string,

      get_page_html
        IMPORTING page_name     TYPE string
        RETURNING VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ss_awd_helper IMPLEMENTATION.
  METHOD format_path.
    DATA(path_length) = strlen( path ) - 1.
    result = to_upper( path+1(path_length) ).
  ENDMETHOD.


  METHOD get_page_html.
    SELECT SINGLE content
      FROM zss_awd_html
      WHERE page_name = @page_name
      INTO @result.
  ENDMETHOD.
ENDCLASS.
