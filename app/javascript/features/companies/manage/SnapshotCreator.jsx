import React from 'react'
import { makeStyles } from "@mui/styles";
import CollectionsIcon from '@mui/icons-material/Collections';
import { Box, Button, Card, Modal, TextField, Typography } from "@mui/material";
import { useDispatch } from "react-redux";
import { clearNotifySnackbarSnapshot, createSnapshotCompany } from "../snapshotCompaniesSlice";
import * as yup from "yup";
import { Controller, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import { clearNotifySnackbar } from "./units/squadsSlice";

const useStyles = makeStyles(theme => ({
  toggleContainer: {
    display: 'inline-flex',
    flexDirection: "row",
    alignItems: "center",
    [theme.breakpoints.down('md')]: {
      flexDirection: "column",
      top: "-135px",
      right: "-16px"
    }
  },
  modal: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    width: 400,
    padding: '1rem',
  },
  textInput: {
    width: '100%',
    '& .MuiOutlinedInput-input': {
      padding: "10px 5px"
    }
  },
  saveRow: {
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-end",
    paddingTop: "0.5rem"
  }
}))

const schema = yup.object().shape({
  name: yup.string().max(50).required("Snapshot name is required"),
})

export const SnapshotCreator = ({ companyId, companyName }) => {
  const dispatch = useDispatch()
  const classes = useStyles()
  const { reset, handleSubmit, setValue, control, formState: { errors } } = useForm({
    resolver: yupResolver(schema),
  });

  const [open, setOpen] = React.useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const saveSnapshot = ({ name }) => {
    dispatch(clearNotifySnackbar())
    dispatch(clearNotifySnackbarSnapshot())
    dispatch(createSnapshotCompany({ sourceCompanyId: companyId, name: name }))
    reset()
    handleClose()
  }

  return (
    <Box className={classes.toggleContainer}>
      <Button variant="contained" color="secondary" size="small" onClick={handleOpen} className={classes.saveButton}>
        <CollectionsIcon/>
        Create Snapshot
      </Button>
      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Card className={classes.modal}>
          <form onSubmit={handleSubmit(saveSnapshot)}>
            <Controller
              name="name" control={control} defaultValue=""
              render={({ field }) => (
                <TextField
                  variant="standard"
                  label="Snapshot Name"
                  color="secondary"
                  error={Boolean(errors.name)}
                  helperText={errors.name?.message}
                  className={classes.textInput} {...field}
                />)}
            />
            <Box className={classes.saveRow}>
              <Button variant="contained" type="submit" color="secondary" size="small"
                      sx={{ marginRight: '9px' }}>Create</Button>
            </Box>
          </form>
        </Card>
      </Modal>
    </Box>
  )
}