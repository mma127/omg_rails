import { precise } from "../../../utils/numbers";

export const getNameFromReference = (reference) => {
  return _.startCase(reference.split('/').pop())
}

export const getTypeName = (data, key) => {
  if (Object.keys(data).includes(key)) {
    return data[key].split('/').pop()
  } else {
    return "-"
  }
}

export const getKey = (data, key) => {
  if (Object.keys(data).includes(key)) {
    return data[key]
  } else {
    return "-"
  }
}

export const getPreciseKey = (data, key, precision = 2) => {
  if (Object.keys(data).includes(key)) {
    return precise(data[key], precision)
  } else {
    return "-"
  }
}
