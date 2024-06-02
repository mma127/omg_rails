import React from 'react'
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';
import darkUnica from "highcharts/themes/dark-unica";
import { calculateRawDps } from "../../../../helpers/stats/dpsCalculator";
import { createDpsDatapoints } from "../../../../helpers/stats/chartDatapoints";

export const HighchartDpsChart = ({ weaponBag }) => {
  darkUnica(Highcharts)
  const dpsValues = calculateRawDps(weaponBag)
  const datapoints = createDpsDatapoints(weaponBag, dpsValues)

  const options = {
    chart: {
      type: "line",

    },
    title: {
      text: "DPS Chart"
    },
    xAxis: {
      min: 0,
      max: 50
    },
    yAxis: {},
    series: [{
      data: datapoints,
      step: 'center',
      name: "dps"
    }]
  }

  return (
    <HighchartsReact highcharts={Highcharts} options={options}/>
  )
}

