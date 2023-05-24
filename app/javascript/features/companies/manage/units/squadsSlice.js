import { createAsyncThunk, createEntityAdapter, createSlice, nanoid } from "@reduxjs/toolkit";
import axios from "axios"
import _ from "lodash"
import { ANTI_ARMOUR, ARMOUR, ASSAULT, CATEGORIES, CORE, INFANTRY, SUPPORT } from "../../../../constants/company";
import { loadSquad } from "./squad";
import {
  addNewCompanyOffmap,
  removeExistingCompanyOffmap,
  removeNewCompanyOffmap
} from "../company_offmaps/companyOffmapsSlice";

const squadsAdapter = createEntityAdapter()

const initialState = squadsAdapter.getInitialState({
  squadsStatus: "idle",
  squadsError: null,
  isChanged: false,
  notifySnackbar: false,
  callinModifiers: [],
  pop: 0,
  man: 0,
  mun: 0,
  fuel: 0,
  [CORE]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [ASSAULT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [INFANTRY]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [ANTI_ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  [SUPPORT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
  selectedSquadTab: null,
  selectedSquadIndex: null,
  selectedSquadUuid: null
})

export const fetchCompanySquads = createAsyncThunk("squads/fetchCompanySquads", async ({ companyId }, { rejectWithValue }) => {
  try {
    const response = await axios.get(`/companies/${companyId}/squads`)
    return response.data
  } catch (err) {
    return rejectWithValue(err.response.data)
  }
})

export const upsertSquads = createAsyncThunk(
  "squads/upsertSquads",
  async ({ companyId, offmaps }, { getState, rejectWithValue }) => {
    const squads = selectCurrentSquads(getState())
    try {
      const response = await axios.post(`/companies/${companyId}/squads`, { squads, offmaps })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

const flattenPlatoonSquads = (topLevelSquads) => {
  const squads = []
  for (const tls of topLevelSquads) {
    // Check if the tls has transportedUnits
    if (!_.isEmpty(tls.transportedSquads)) {
      // If yes, build list of transported squad uuids
      const transportedSquadUuids = []
      for (const transportedSquad of _.values(tls.transportedSquads)) {
        // for each squad, get uuid and insert into transportedSquadUuids
        transportedSquadUuids.push(transportedSquad.uuid)
        // overwrite squad's transportUuid with tls uuid just in case (should never be different)
        // append transported squads to squads list
        squads.push({ ...transportedSquad, transportUuid: tls.uuid })
      }
      // done with transported squads, set transportedSquadUuids on transport squad
      // Clear transportedSquads so that isn't in payload
      // append transport squad to squads list
      squads.push({ ...tls, transportedSquadUuids: transportedSquadUuids, transportedSquads: null })
    } else {
      squads.push(tls)
    }
  }
  return squads
}

/**
 * Flattens all squads in the categories/index object into one list for the backend.
 * If a squad is a transport and has transportedUnits, construct a list of all transported squad uuids and attach to
 * the transport squad.
 * Transported squads will retain their transportUuid
 */
const selectCurrentSquads = state => {
  let squads = []
  CATEGORIES.forEach(category => {
    const squadsForCat = state.squads[category]
    Object.values(squadsForCat)
      .filter(indexSquads => !_.isEmpty(indexSquads))
      .forEach(indexSquads => {
        squads = squads.concat(
          flattenPlatoonSquads(Object.values(indexSquads))
        )
      })
  })
  return squads
}

/**
 * Given a list of squad objects,
 * @param squads: Array of squad objects, including tab and index values to identify which tab index the squad belongs to
 * @returns object containing keys of Tab Categories, and values of objects representing the 8 tab indices
 */
const buildNewSquadTabs = (squads) => {
  const tabs = {
    [CORE]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [ASSAULT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [INFANTRY]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [ANTI_ARMOUR]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} },
    [SUPPORT]: { 0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}, 7: {} }
  }
  const transportedSquads = []
  squads.forEach(squad => {
    // For each squad, add to the platoon if the squad does not have a transportUuid. This means the squad is at the top level
    // If transported, add to the transportedSquads array and iterate later (the transport may not have been seen yet in this loop)
    if (_.isNil(squad.transportUuid)) {
      const platoon = tabs[squad.tab][squad.index]
      platoon[squad.uuid] = loadSquad(squad)
    } else {
      transportedSquads.push(squad)
    }
  })

  if (transportedSquads.length > 0) {
    // For transported squads, locate the transport and set on the transport's transportedSquads mapping
    transportedSquads.forEach(squad => {
      const transport = tabs[squad.tab][squad.index][squad.transportUuid]
      const transportedSquads = { ...transport.transportedSquads, [squad.uuid]: loadSquad(squad) }
      const combinedPop = transport.combinedPop + parseFloat(squad.pop)
      const usedSquadSlots = transport.usedSquadSlots + 1
      const usedModelSlots = transport.usedModelSlots + squad.totalModelCount
      tabs[squad.tab][squad.index][squad.transportUuid] = {
        ...transport,
        combinedPop: combinedPop,
        transportedSquads: transportedSquads,
        usedSquadSlots: usedSquadSlots,
        usedModelSlots: usedModelSlots
      }
    })
  }
  return tabs
}

const squadsSlice = createSlice({
  name: "squads",
  initialState,
  reducers: {
    /**
     * For a non-transported squad, simply add the squad by uuid to the platoon at the squad's tab and index
     */
    addNonTransportedSquad(state, action) {
      const { uuid, index, tab } = action.payload
      const platoon = state[tab][index]
      if (!Object.keys(platoon).includes(uuid)) {
        platoon[uuid] = action.payload
      }
      state.isChanged = true
    },
    /**
     * For a transported squad, find the transporting squad by the squad's transportUuid, index, and tab.
     * If the transporting
     */
    addTransportedSquad(state, action) {
      const { newSquad, transportUuid } = action.payload
      const { uuid, index, tab, totalModelCount, pop } = newSquad
      const platoon = state[tab][index]
      if (_.has(platoon, transportUuid)) {
        const transport = platoon[transportUuid]
        let transportedSquads = transport.transportedSquads
        if (!_.isPlainObject(transport.transportedSquads)) {
          transportedSquads = {}
        }
        if (!_.has(transportedSquads, uuid)) {
          const usedSquadSlots = (transport.usedSquadSlots || 0)
          const usedModelSlots = (transport.usedModelSlots || 0)
          // If the transporting squad has both squad and model slots left, add the squad to the transport
          if (usedSquadSlots + 1 <= transport.transportSquadSlots && usedModelSlots + totalModelCount <= transport.transportModelSlots) {
            transportedSquads[uuid] = newSquad
            transport.transportedSquads = transportedSquads
            transport.usedSquadSlots = usedSquadSlots + 1
            transport.usedModelSlots = usedModelSlots + totalModelCount
            transport.combinedPop = parseFloat(transport.combinedPop) + parseFloat(pop)
          } else {
            // Otherwise, add the squad to the platoon
            if (!Object.keys(platoon).includes(uuid)) {
              platoon[uuid] = newSquad
            }
          }
        }
      }
      state.isChanged = true
    },
    removeSquad(state, action) {
      const { uuid, index, tab } = action.payload
      const platoon = state[tab][index]
      if (Object.keys(platoon).includes(uuid)) {
        const squad = platoon[uuid]
        // Check if this squad has transportedSquads. If so, move them to the platoon level first
        const transportedSquads = _.values(squad.transportedSquads)
        if (!_.isEmpty(transportedSquads)) {
          transportedSquads.forEach(ts => {
            platoon[ts.uuid] = { ...ts, transportUuid: null }
          })
        }

        delete platoon[uuid]
      }
      state.isChanged = true
    },
    removeTransportedSquad(state, action) {
      const { squad, transportUuid } = action.payload
      const platoon = state[squad.tab][squad.index]
      if (_.has(platoon, transportUuid)) {
        const transport = platoon[transportUuid]
        if (_.has(transport.transportedSquads, squad.uuid)) {
          transport.combinedPop = parseFloat(transport.combinedPop) - parseFloat(squad.pop)
          transport.usedSquadSlots -= 1
          transport.usedModelSlots -= squad.totalModelCount
          delete transport.transportedSquads[squad.uuid]
        }
      }
      state.isChanged = true
    },
    /** Moving a squad from the old index and tab to a new index and tab, with optional target transportUuid if the
     * squad is moving into a transport in the target platoon.
     * If the squad has non-null transportUuid, it is located in a transport in its source platoon and will need to be
     * removed */
    moveSquad(state, action) {
      const { squad, unit, newIndex, newTab, targetTransportUuid } = action.payload
      const uuid = squad.uuid
      const oldPlatoon = state[squad.tab][squad.index]
      let workingSquad, sourceTransport
      if (_.isNil(squad.transportUuid)) {
        // Not transported
        workingSquad = oldPlatoon[uuid]
        delete oldPlatoon[uuid]
      } else {
        // Source is transport
        sourceTransport = oldPlatoon[squad.transportUuid]
        workingSquad = sourceTransport.transportedSquads[uuid]

        // Uncouple squad from the source transport
        workingSquad.transportUuid = null
        sourceTransport.combinedPop = parseFloat(sourceTransport.combinedPop) - parseFloat(workingSquad.pop)
        sourceTransport.usedSquadSlots -= 1
        sourceTransport.usedModelSlots -= workingSquad.totalModelCount
        delete sourceTransport.transportedSquads[uuid]
      }
      workingSquad.tab = newTab
      workingSquad.index = newIndex
      const newPlatoon = state[newTab][newIndex]

      if (_.isNil(targetTransportUuid)) {
        // Moving into platoon
        newPlatoon[uuid] = workingSquad
      } else {
        // Moving into transport
        const targetTransport = newPlatoon[targetTransportUuid]
        let transportedSquads = targetTransport.transportedSquads
        if (!_.isPlainObject(targetTransport.transportedSquads)) {
          transportedSquads = {}
        }
        transportedSquads[uuid] = workingSquad
        workingSquad.transportUuid = targetTransportUuid
        targetTransport.transportedSquads = transportedSquads
        targetTransport.usedSquadSlots = (targetTransport.usedSquadSlots || 0) + 1
        targetTransport.usedModelSlots = (targetTransport.usedModelSlots || 0) + workingSquad.totalModelCount
        targetTransport.combinedPop = parseFloat(targetTransport.combinedPop) + parseFloat(workingSquad.pop)
      }

      state.isChanged = true
    },
    resetSquadState: () => initialState,
    clearNotifySnackbar(state) {
      state.notifySnackbar = false
    },
    showSnackbar: (state, action) => {
      state.notifySnackbar = true
    },
    setSelectedSquadAccess: (state, action) => {
      state.selectedSquadTab = action.payload.tab
      state.selectedSquadIndex = action.payload.index
      state.selectedSquadUuid = action.payload.uuid
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanySquads.pending, (state, action) => {
        state.squadsStatus = "pending"
        state.squadsError = null
      })
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        squadsAdapter.setAll(state, action.payload.squads)
        const newTabs = buildNewSquadTabs(action.payload.squads)
        for (const tabName of CATEGORIES) {
          state[tabName] = newTabs[tabName]
        }

        state.callinModifiers = action.payload.callinModifiers
        state.squadsStatus = "idle"
      })
      .addCase(fetchCompanySquads.rejected, (state, action) => {
        state.squadsStatus = "idle"
        state.squadsError = action.payload.error
      })

      .addCase(upsertSquads.pending, (state, action) => {
        state.squadsStatus = "pending"
        state.squadsError = null
        state.notifySnackbar = false
      })
      .addCase(upsertSquads.fulfilled, (state, action) => {
        // action.payload.squads & action.payload.availableUnits
        squadsAdapter.setAll(state, action.payload.squads)
        const newTabs = buildNewSquadTabs(action.payload.squads)
        for (const tabName of CATEGORIES) {
          state[tabName] = newTabs[tabName]
        }
        state.squadsStatus = "idle"
        state.isChanged = false
        state.notifySnackbar = true
      })
      .addCase(upsertSquads.rejected, (state, action) => {
        state.squadsStatus = "idle"
        state.squadsError = action.payload.error
        state.notifySnackbar = true
      })

      .addCase(addNewCompanyOffmap, (state) => {
        state.isChanged = true
      })
      .addCase(removeNewCompanyOffmap, (state) => {
        state.isChanged = true
      })
      .addCase(removeExistingCompanyOffmap, (state) => {
        state.isChanged = true
      })
  }
})

export default squadsSlice.reducer

export const {
  addNonTransportedSquad,
  addTransportedSquad,
  removeSquad,
  removeTransportedSquad,
  moveSquad,
  resetSquadState,
  clearNotifySnackbar,
  showSnackbar,
  setSelectedSquadAccess
} = squadsSlice.actions

export const {
  selectAll: selectAllSquads,
  selectById: selectSquadById
} = squadsAdapter.getSelectors(state => state.squads)

export const selectCoreSquads = state => state.squads[CORE]
export const selectAssaultSquads = state => state.squads[ASSAULT]
export const selectInfantrySquads = state => state.squads[INFANTRY]
export const selectArmourSquads = state => state.squads[ARMOUR]
export const selectAntiArmourSquads = state => state.squads[ANTI_ARMOUR]
export const selectSupportSquads = state => state.squads[SUPPORT]

export const selectSquadsInTabIndex = (state, tab, index) => state.squads[tab][index]

export const selectSquadInTabIndexUuid = (state, tab, index, uuid) => state.squads[tab][index][uuid]
export const selectSquadInTabIndexTransportUuid = (state, tab, index, transportUuid, uuid) => {
  const transport = state.squads[tab][index][transportUuid]
  return transport.transportedSquads[uuid]
}

export const selectCallinModifiers = state => state.squads.callinModifiers

export const selectSelectedSquad = state => {
  const tab = state.squads.selectedSquadTab,
    index = state.squads.selectedSquadIndex,
    uuid = state.squads.selectedSquadUuid;
  if (!_.isNil(tab) && !_.isNil(index) && !_.isNil(uuid)) {
    return state.squads[tab][index][uuid]
  }
  return null
}
