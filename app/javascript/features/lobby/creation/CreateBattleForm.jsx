import React from 'react'
import { Alert, Box, Button, FormControl, Grid, InputLabel, MenuItem, Select, TextField, Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { Controller, useForm, useWatch } from "react-hook-form";
import * as yup from "yup"
import { yupResolver } from "@hookform/resolvers/yup";
import { useDispatch, useSelector } from "react-redux";
import { createBattle, selectIsPending } from "../lobbySlice";
import { ErrorTypography } from "../../../components/ErrorTypography";
import { selectAllCompanies } from "../../companies/companiesSlice";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { CompanySelectTooltip } from "./CompanySelectTooltip";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";

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

const CompanyMenuItem = ({ company }) => {
  const classes = useStyles()
  return (
    <Tooltip title={<CompanySelectTooltip company={company} /> } placement="right" arrow>
      <img src={doctrineImgMapping[company.doctrineName]} alt={company.doctrineName}
           className={classes.optionImage}/>
    </Tooltip>
  )
}

export const CreateBattleForm = ({ onCreateCallback }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const companies = useSelector(selectAllCompanies)
  const sortedCompanies = companies.sort(nameSort);
  const isPending = useSelector(selectIsPending)
  const activeRuleset = useSelector(selectActiveRuleset)

  const { reset, handleSubmit, setValue, control, formState: { errors } } = useForm({
    resolver: yupResolver(schema),
  });

  const onSubmit = ({ name, size, initialCompanyId }) => {
    if (name.length === 0) {
      name = `${size}v${size}`
    }
    // Submit
    dispatch(createBattle({ name, size, rulesetId: activeRuleset.id, initialCompanyId }))
    onCreateCallback()
  }

  const selectedCompanyId = useWatch({
    control,
    name: "initialCompanyId",
  })

  let warnContent
  const floatingResources = []
  if (selectedCompanyId) {
    const selectedCompany = companies.find(c => c.id === selectedCompanyId)
    if (selectedCompany?.man > 100) {
      floatingResources.push(`${selectedCompany.man} man`)
    }
    if (selectedCompany?.mun > 100) {
      floatingResources.push(`${selectedCompany.mun} mun`)
    }
    if (selectedCompany?.fuel > 100) {
      floatingResources.push(`${selectedCompany.fuel} fuel`)
    }

    if (floatingResources.length > 0) {
      warnContent = (
        <Alert severity="warning">Selected company has excess {floatingResources.join(', ')}</Alert>
      )
    }
  }

  return (
    <Box>
      <form onSubmit={handleSubmit(onSubmit)}>
        <Grid container>
          <Grid item xs={5}>
            <Box pl={"9px"} pb={2}>
              <Controller
                name="name" control={control} defaultValue=""
                render={({ field }) => (
                  <TextField
                    variant="standard"
                    label="Name (optional)"
                    color="secondary"
                    error={Boolean(errors.name)}
                    helperText={errors.name?.message}
                    className={classes.textInput} {...field}
                  />)}
              />
            </Box>
          </Grid>
          <Grid item xs={2}>
            <Box pt={2} pb={2} sx={{ display: "flex", justifyContent: "center" }}>
              <Controller
                name="size" control={control} defaultValue={3}
                render={({ field }) => (
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
          <Grid item xs={5}>
            <Box pt={2} pb={2}>
              <Controller
                name="initialCompanyId" control={control} defaultValue=""
                render={({ field }) => (
                  <FormControl sx={{ minWidth: '120px' }}>
                    <InputLabel id="join-company-select-label">Company</InputLabel>
                    <Select
                      labelId="join-company-select"
                      id="join-company-select"
                      label="Company"
                      color="secondary"
                      error={Boolean(errors.initialCompanyId)}
                      onChange={e => {
                        onChange(e)
                        field.onChange(e)
                      } }
                      {...field}
                    >
                      {sortedCompanies.map(c => <MenuItem key={c.id} value={c.id} className={classes.optionMenuItem}>
                        <CompanyMenuItem company={c} />
                      </MenuItem>)}
                    </Select>
                  </FormControl>)}
              />
              <ErrorTypography pl={"9px"}>{errors.initialCompanyId?.message}</ErrorTypography>
            </Box>
          </Grid>
        </Grid>
        {warnContent}
        <Grid container pt={2} justifyContent="center">
          <Button variant="contained" type="submit" color="secondary" size="small"
                  sx={{ marginRight: '9px' }} disabled={isPending}>Create</Button>
        </Grid>
      </form>
    </Box>
  )
}
