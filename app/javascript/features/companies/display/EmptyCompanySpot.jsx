import React from 'react'
import { Box, Card, Typography } from "@mui/material";

export const EmptyCompanySpot = () => {
  return (
    <Box ml={5} mr={5} mt={1} mb={1} sx={{ maxWidth: '600px', flexGrow: 1 }} justifyContent="center">
      <Card elevation={3} sx={{ padding: '16px', height: '100px' }}>
        <Typography variant="h5" pl="9px" gutterBottom>Open Company Slot</Typography>
      </Card>
    </Box>
  )
}