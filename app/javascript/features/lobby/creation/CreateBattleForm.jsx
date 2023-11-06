import React, {useEffect, useState} from 'react'
import {
  Box,
  Button,
  Card, FormControl,
  Grid,
  InputLabel,
  MenuItem,
  Radio,
  RadioGroup,
  Select,
  TextField, Tooltip,
  Typography
} from "@mui/material";
import {makeStyles} from "@mui/styles";
import {Controller, useForm} from "react-hook-form";
import * as yup from "yup"
import {yupResolver} from "@hookform/resolvers/yup";
import {useDispatch, useSelector} from "react-redux";
import {createBattle} from "../lobbySlice";
import {ErrorTypography} from "../../../components/ErrorTypography";
import {selectAllCompanies} from "../../companies/companiesSlice";
import {doctrineImgMapping} from "../../../constants/doctrines";

const useStyles = makeStyles(theme => ({
  textInput: {
    width: '90%',
    '& .MuiOutlinedInput-input': {
      padding: "10px 5px"
    }
  },
  formBottomRow: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between'
  },
  optionMenuItem: {
    paddingTop: 0,
    paddingBottom: 0,
    justifyContent: "center",
    width: '120px'
  },
  optionImage: {
    height: '60px',
    width: '120px'
  }
}))

const schema = yup.object().shape({
  name: yup.string().max(50),
  size: yup.number().required("Battle size is required"),
  // initialCompanyId: yup.number().required("Joining company is required").positive("Joining company is required")
  initialCompanyId: yup
    .number()
    .transform(value => (isNaN(value) ? undefined : value))
    .required("Joining company is required")
})

const nameSort = (a, b) => {
  const docA = a.doctrineDisplayName.toUpperCase();
  const docB = b.doctrineDisplayName.toUpperCase();
  if (docA < docB) {
    return -1;
  }
  if (docA > docB) {
    return 1;
  }
  return 0;
}

export const CreateBattleForm = ({rulesetId, onCreateCallback}) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const companies = useSelector(selectAllCompanies)
  const sortedCompanies = companies.sort(nameSort);

  const {reset, handleSubmit, setValue, control, formState: {errors}} = useForm({
    resolver: yupResolver(schema),
  });

  const onSubmit = ({name, size, initialCompanyId}) => {
    if (name.length === 0) {
      name = `${size}v${size}`
    }
    // Submit
    dispatch(createBattle({name, size, rulesetId, initialCompanyId}))
    onCreateCallback()
  }

  return (
    <Box>
      <form onSubmit={handleSubmit(onSubmit)}>
        <Grid container>
          <Grid item xs={6}>
            <Box pl={"9px"} pb={2}>
              <Controller
                name="name" control={control} defaultValue=""
                render={({field}) => (
                  <TextField
                    variant="standard"
                    label="Name"
                    color="secondary"
                    error={Boolean(errors.name)}
                    helperText={errors.name?.message}
                    className={classes.textInput} {...field}
                  />)}
              />
            </Box>
          </Grid>
          <Grid item xs={6}>
            <Box pt={2} pb={2}>
              <Controller
                name="size" control={control} defaultValue={3}
                render={({field}) => (
                  <FormControl>
                    <InputLabel id="battle-size-select-label">Size</InputLabel>
                    <Select
                      labelId="battle-size-select-label"
                      id="battle-size-select"
                      label="Size"
                      color="secondary"
                      error={Boolean(errors.size)}
                      {...field}
                    >
                      <MenuItem value={1}>1v1</MenuItem>
                      <MenuItem value={2}>2v2</MenuItem>
                      <MenuItem value={3}>3v3</MenuItem>
                      <MenuItem value={4}>4v4</MenuItem>
                    </Select>
                  </FormControl>)}
              />
              <ErrorTypography pl={"9px"}>{errors.size?.message}</ErrorTypography>
            </Box>
          </Grid>
        </Grid>
        <Box pt={2} pb={2}>
          <Controller
            name="initialCompanyId" control={control} defaultValue=""
            render={({field}) => (
              <FormControl sx={{minWidth: '120px'}}>
                <InputLabel id="join-company-select-label">Company</InputLabel>
                <Select
                  labelId="join-company-select"
                  id="join-company-select"
                  label="Company"
                  color="secondary"
                  error={Boolean(errors.initialCompanyId)}
                  {...field}
                >
                  {sortedCompanies.map(c => <MenuItem key={c.id} value={c.id} className={classes.optionMenuItem}>
                    <Tooltip title={c.name} placement="right" arrow>
                      <img src={doctrineImgMapping[c.doctrineName]} alt={c.doctrineName}
                           className={classes.optionImage}/>
                    </Tooltip>
                  </MenuItem>)}
                </Select>
              </FormControl>)}
          />
          <ErrorTypography pl={"9px"}>{errors.initialCompanyId?.message}</ErrorTypography>
        </Box>
        <Grid container pt={4} justifyContent="center">
          <Button variant="contained" type="submit" color="secondary" size="small"
                  sx={{marginRight: '9px'}}>Create</Button>
        </Grid>
      </form>
    </Box>
  )
}
