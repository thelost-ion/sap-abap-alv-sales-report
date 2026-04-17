REPORT zsales_order_report.
TABLES: vbak, vbap.
TYPE-POOLS: slis.
TYPES: BEGIN OF ty_sales,
         vbeln TYPE vbak-vbeln,
         posnr TYPE vbap-posnr,
         matnr TYPE vbap-matnr,
         kwmeng TYPE vbap-kwmeng,
         netwr TYPE vbap-netwr,
         waerk TYPE vbak-waerk,
         vkorg TYPE vbak-vkorg,
       END OF ty_sales.
DATA: it_sales TYPE TABLE OF ty_sales,
      wa_sales TYPE ty_sales.
DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln.
START-OF-SELECTION.
SELECT a~vbeln
       b~posnr
       b~matnr
       b~kwmeng
       b~netwr
       a~waerk
       a~vkorg
  INTO TABLE it_sales
  FROM vbak AS a
  INNER JOIN vbap AS b
  ON a~vbeln = b~vbeln
  WHERE a~vbeln IN s_vbeln.
SORT it_sales BY vbeln.
PERFORM build_fieldcat.
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    it_fieldcat = it_fieldcat
  TABLES
    t_outtab    = it_sales.
FORM build_fieldcat.
  PERFORM add_field USING 'VBELN' 'Sales Order'.
  PERFORM add_field USING 'POSNR' 'Item Number'.
  PERFORM add_field USING 'MATNR' 'Material'.
  PERFORM add_field USING 'KWMENG' 'Quantity'.
  PERFORM add_field USING 'NETWR' 'Net Value'.
  PERFORM add_field USING 'WAERK' 'Currency'.
  PERFORM add_field USING 'VKORG' 'Sales Org'.
ENDFORM.
FORM add_field USING field_name field_text.
  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = field_name.
  wa_fieldcat-seltext_m = field_text.
  APPEND wa_fieldcat TO it_fieldcat.
ENDFORM.
