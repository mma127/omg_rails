import React from 'react'
import { Alert, Snackbar } from "@mui/material";

export const AlertSnackbar = ({isOpen, setIsOpen, handleClose, severity, content}) => {
  return (
    <Snackbar
      anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      open={isOpen}
      autoHideDuration={5000}
      onClose={() => setIsOpen(false)}
    >
      <Alert onClose={handleClose} severity={severity} sx={{ width: '100%' }}>
        {content}
      </Alert>
    </Snackbar>
  )
}