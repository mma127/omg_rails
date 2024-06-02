import React from 'react'
import { calculateRawDps } from "../../../../helpers/stats/dpsCalculator";
import { createDpsDatapoints } from "../../../../helpers/stats/chartDatapoints";
import { Line } from "react-chartjs-2";

export const ChartJsDpsChart = ({ weaponBag }) => {
  const dpsValues = calculateRawDps(weaponBag, false)
  const datapoints = createDpsDatapoints(weaponBag, dpsValues)

  const movingDpsValues = calculateRawDps(weaponBag, true)
  const movingDatapoints = createDpsDatapoints(weaponBag, movingDpsValues)

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: 'top',
      },
      title: {
        display: true,
        text: 'Raw DPS',
      },
    },
    scales: {
      x: {
        beginAtZero: true,
        suggestedMin: 0,
        max: 50,
        title: { display: true, text: "Range" }
      },
      y: {
        suggestedMin: 0,
        suggestedMax: 20,
        title: { display: true, text: "Damage per second" }
      }
    },
    elements: {
      line: {
        stepped: "middle"
      }
    }
  };

  const labels = Array.from({ length: weaponBag.rangeLong }, (_, idx) => idx);

  const chartData = {
    labels,
    datasets: [
      {
        label: 'Stationary',
        data: datapoints,
        borderColor: 'rgb(255, 99, 132)',
        // backgroundColor: 'rgba(255, 99, 132, 0.5)',
      },
      {
        label: "Moving",
        data: movingDatapoints,
        borderColor: 'rgb(75, 192, 192)',
      }
    ],
  };


  return (
    <Line data={chartData} options={options}/>
  )
}

