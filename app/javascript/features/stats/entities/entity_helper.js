import { precise } from "../../../utils/numbers";
import _ from "lodash";

export const getNameFromReference = (reference) => {
  return _.startCase(reference.split('/').pop())
}

export const getTypeName = (data, key) => {
  if (data && Object.keys(data).includes(key)) {
    return data[key].split('/').pop()
  } else {
    return "-"
  }
}

export const getKey = (data, key) => {
  if (data && Object.keys(data).includes(key)) {
    return data[key]
  } else {
    return "-"
  }
}

export const getPreciseKey = (data, key, precision = 2) => {
  if (data && Object.keys(data).includes(key)) {
    return precise(data[key], precision)
  } else {
    return "-"
  }
}
