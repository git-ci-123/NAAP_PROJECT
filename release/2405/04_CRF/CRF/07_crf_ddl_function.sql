--liquibase formatted sql
--changeset Swetha.H:CRF_DDL_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

  CREATE OR REPLACE EDITIONABLE FUNCTION GETNEWCHARTNAME (
  oldcharttype IN VARCHAR2)
RETURN VARCHAR2
IS
BEGIN
  IF oldcharttype ='Bar chart' THEN
    RETURN 'barChart';
  ELSIF oldcharttype ='Pie chart' THEN
    RETURN 'pieChart';
  ELSIF oldcharttype ='HoriBarChart' THEN
    RETURN 'horiBarChart';
  ELSIF oldcharttype ='Line chart' THEN
    RETURN 'lineChart';
  ELSIF oldcharttype ='FunnelChart' THEN
    RETURN 'funnelChart';
  ELSIF oldcharttype ='AreaChart' THEN
    RETURN 'areaChart';
  ELSIF oldcharttype ='StackedBarChart' THEN
    RETURN 'stackedBarChart';
  ELSIF oldcharttype ='MultipleBarChart' THEN
    RETURN 'multipleBarChart';
  ELSIF oldcharttype ='Combinational chart' THEN
    RETURN 'barWithLineChart';
  ELSIF oldcharttype ='CombinationalChart' THEN
    RETURN 'multiBarWithLineChart';
  ELSIF oldcharttype ='MultiBarLine chart' THEN
    RETURN 'multiBarWithLineChart';
  ELSIF oldcharttype ='Table' THEN
    RETURN 'table';
  ELSIF oldcharttype ='Gauge chart' THEN
    RETURN 'gaugeKpi';
  ELSIF oldcharttype ='KPI Chart' THEN
    RETURN 'kpiChart';
  ELSIF oldcharttype ='3D Bar chart' THEN
    RETURN 'threeDBarChart';
  ELSIF oldcharttype ='3D Pie chart' THEN
    RETURN 'threeDPieChart';
  ELSIF oldcharttype ='3DHoriBarChart' THEN
    RETURN 'threeDHoriBarChart';
  ELSIF oldcharttype ='3DMultipleBarChart' THEN
    RETURN 'threeDStackedBarChart';
  ELSIF oldcharttype ='3DStackedBarChart' THEN
    RETURN 'threeDMultipleBarChart';
  END IF;
END;
