import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import axios from "axios";

const initialState = {
  data: null,
  status: "idle"
}

export const fetchPlayer = createAsyncThunk("player/fetchPlayer", async () => {
  const response = await axios.get('/api/player')
  return response.data
})

const playerSlice = createSlice({
  name: "player",
  initialState,
  reducers: {

  },
  extraReducers(builder) {
    builder
      .addCase(fetchPlayer.pending, (state) => {
        state.status = "pending"
      })
      .addCase(fetchPlayer.fulfilled, (state, action) => {
        state.status = "fulfilled"
        state.data = action.payload
      })
      .addCase(fetchPlayer.rejected, (state) => {
        state.status = "rejected"
        state.data = null
      })
  }
})

export default playerSlice.reducer

export const selectPlayer = state => state.player.data
export const selectIsAuthed = state => Boolean(state.player.data)
