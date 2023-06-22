import { createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import { fetchCompanySquads, removeSquad, removeTransportedSquad, upsertSquads } from "../units/squadsSlice";
import { CATEGORIES } from "../../../../constants/company";
import { loadSquadUpgrade } from "./squadUpgrade";
import { removeNewCompanyOffmap } from "../company_offmaps/companyOffmapsSlice";

const find_or_memo = (memo, source, id) => {
  if (id in memo) {
    return memo[id]
  } else {
    const target = source.find(ele => ele.id === id)
    memo[id] = target
    return target
  }
}

const populateSquadUpgradesTree = (payload, upgrades, availableUpgrades, squads) => {
  const result = {}
  const upgradesMemo = {}
  const availableUpgradesMemo = {}
  const squadsMemo = {}
  payload.forEach(su => {
    const availableUpgrade = find_or_memo(availableUpgradesMemo, availableUpgrades, su.availableUpgradeId)
    const upgrade = find_or_memo(upgradesMemo, upgrades, availableUpgrade.upgradeId)
    const squad = find_or_memo(squadsMemo, squads, su.squadId)
    const newSquadUpgrade = loadSquadUpgrade(su, upgrade, availableUpgrade, squad)
    _.setWith(result, `[${newSquadUpgrade.tab}][${newSquadUpgrade.index}][${newSquadUpgrade.squadUuid}][${newSquadUpgrade.uuid}]`, newSquadUpgrade, Object)
  })
  return result
}

const squadUpgradesAdapter = createEntityAdapter()
const initialState = squadUpgradesAdapter.getInitialState({
  currentSquadUpgrades: {},
  isChanged: false
})

const squadUpgradesSlice = createSlice({
  name: "squadUpgrades",
  initialState,
  reducers: {
    addNewSquadUpgrade(state, action) {
      const { newSquadUpgrade } = action.payload
      const tab = newSquadUpgrade.tab,
        index = newSquadUpgrade.index,
        squadUuid = newSquadUpgrade.squadUuid,
        uuid = newSquadUpgrade.uuid
      _.setWith(state.currentSquadUpgrades, `[${tab}][${index}][${squadUuid}][${uuid}]`, newSquadUpgrade, Object)
      state.isChanged = true
    },
    removeSquadUpgrade(state, action) {
      const { squadUpgrade } = action.payload

      delete state.currentSquadUpgrades[squadUpgrade.tab][squadUpgrade.index][squadUpgrade.squadUuid][squadUpgrade.uuid]
      state.isChanged = true
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        squadUpgradesAdapter.setAll(state, action.payload.squadUpgrades)
        state.currentSquadUpgrades = populateSquadUpgradesTree(action.payload.squadUpgrades, action.payload.upgrades, action.payload.availableUpgrades, action.payload.squads)
        state.isChanged = false
      })
      .addCase(upsertSquads.fulfilled, (state, action) => {
        squadUpgradesAdapter.setAll(state, action.payload.squadUpgrades)
        state.currentSquadUpgrades = populateSquadUpgradesTree(action.payload.squadUpgrades, action.payload.upgrades, action.payload.availableUpgrades, action.payload.squads)
        state.isChanged = false
      })
      .addCase(removeSquad, (state, action) => {
        const { uuid, index, tab } = action.payload

        delete state.currentSquadUpgrades[tab][index][uuid]
        state.isChanged = true
      })
      .addCase(removeTransportedSquad, (state, action) => {
        const { uuid, index, tab } = action.payload

        delete state.currentSquadUpgrades[tab][index][uuid]
        state.isChanged = true
      })
  }
})

export default squadUpgradesSlice.reducer
export const { addNewSquadUpgrade, removeSquadUpgrade } = squadUpgradesSlice.actions

export const {
  selectAll: selectAllSquadUpgrades,
  selectById: selectSquadUpgradeById
} = squadUpgradesAdapter.getSelectors(state => state.upgrades)

export const selectSquadUpgradesForSquad = (state, tab, index, squadUuid) => _.values(state.squadUpgrades.currentSquadUpgrades[tab]?.[index]?.[squadUuid])

const transformForApi = squadUpgrade => {
  return {
    id: squadUpgrade.id,
    availableUpgradeId: squadUpgrade.availableUpgradeId,
    squadId: squadUpgrade.squadId,
    squadUuid: squadUpgrade.squadUuid
  }
}
const flattenIndexSquads = (squads) => {
  return squads.reduce((acc, current) => acc.concat(_.values(current).map(transformForApi)), [])
}
/**
 * Flatten all squad upgrades into one list for the backend
 */
export const selectFlatSquadUpgrades = (state) => {
  let squadUpgrades = []
  CATEGORIES.forEach(category => {
    const indices = state.squadUpgrades.currentSquadUpgrades[category]
    _.values(indices)
      .filter(indexSquads => !_.isEmpty(indexSquads))
      .forEach(indexSquads => {
        squadUpgrades = squadUpgrades.concat(
          flattenIndexSquads(_.values(indexSquads))
        )
      })
  })
  return squadUpgrades
}
