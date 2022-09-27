#!/usr/bin/env node

// Copyright 2022 Styra Inc. All rights reserved.
// Use of this source code is governed by an Apache2
// license that can be found in the LICENSE file.

// See: ./validator/README.md for usage

require = require('esm-wallaby')(module)

const Fs = require('fs')
const Os = require('os')
const Path = require('path')
const Util = require('util')

const Yaml = require('js-yaml')

const {log: println} = console
const [readdir, readFile, stat] = [Fs.readdir, Fs.readFile, Fs.stat].map(Util.promisify)

class SchemaError extends Error {
  constructor(...params) {
    super(...params)

    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, SchemaError)
    }

    this.name = 'SchemaError'
  }
}

function isPlainObject(input) {
  return input && !Array.isArray(input) && typeof input === 'object'
}

const ParameterTypes = {
  NUMBER: 'number',
  OBJECT: 'object',
  SET_OF_NUMBERS: 'set_of_numbers',
  SET_OF_STRINGS: 'set_of_strings',
  STRING: 'string'
}

const parameterTypes = [ParameterTypes.STRING, ParameterTypes.SET_OF_STRINGS, ParameterTypes.NUMBER, ParameterTypes.SET_OF_NUMBERS, ParameterTypes.OBJECT]
function checkParameters(parameters) {
  if (!Array.isArray(parameters)) {
    throw new SchemaError('parameters must be an array')
  }

  for (let i = 0; i < parameters.length; i++) {
    const parameter = parameters[i]

    if (!isPlainObject(parameter)) {
      throw new SchemaError(`each parameter in parameters should be an object`)
    }

    if (!parameterTypes.includes(parameter.type)) {
      throw new SchemaError(`Unknown parameter's type in parameters ${parameter.type}`)
    }

    if (typeof parameter.name !== 'string') {
      throw new SchemaError(`parameter's name in parameters should be a string`)
    }

    if (parameter.label && typeof parameter.label !== 'string') {
      throw new SchemaError(`parameter's label in parameters should be a string`)
    }

    if (parameter.required && typeof parameter.required !== 'boolean') {
      throw new SchemaError(`parameter's required in parameters should be a string`)
    }

    if (parameter.placeholder && typeof parameter.placeholder !== 'string') {
      throw new SchemaError(`parameter string's placeholder in parameters should be a string`)
    }

    if (parameter.type === ParameterTypes.STRING) {
      if (parameter.default && typeof parameter.default !== 'string') {
        throw new SchemaError(`parameter string's default in parameters should be a string`)
      }

      const items = parameter.items
      if (items && !(Array.isArray(items) || isPlainObject(items))) {
        throw new SchemaError(`parameter string's items in parameters should be an array or object`)
      }

      if (Array.isArray(items)) {
        for (let i = 0; i < items.length; i++) {
          const item = items[i]

          if (typeof item !== 'string') {
            throw new SchemaError(`parameter string's items array in parameters should be strings`)
          }
        }
      }

      if (isPlainObject(items)) {
        const query = items.query
        if (typeof query !== 'string') {
          throw new SchemaError(`parameter string's items object's query in parameters should be a string`)
        }

        const datasource = items.datasource
        const library = items.library
        const package = items.package

        if ((!!datasource + !!library + !!package) !== 1) {
          throw new SchemaError(`datasource, library and package are mutually exclusive`)
        }

        if (datasource && typeof datasource !== 'string') {
          throw new SchemaError(`datasource should be a string`)
        }

        if (library && typeof library !== 'string') {
          throw new SchemaError(`library should be a string`)
        }

        if (package && typeof package !== 'string') {
          throw new SchemaError(`package should be a string`)
        }
      }
    }

    if (parameter.type === ParameterTypes.SET_OF_STRINGS) {
      if (parameter.default && !Array.isArray(parameter.default)) {
        throw new SchemaError(`parameter set_of_strings's default in parameters should be an array`)
      } else if (parameter.default) {
        if (!parameter.default.every((v) => typeof v === 'string')) {
          throw new SchemaError(`parameter set_of_strings's default array in parameters should have string values`)
        }
      }

      const items = parameter.items
      if (items && !(Array.isArray(items) || isPlainObject(items))) {
        throw new SchemaError(`parameter set_of_strings's items in parameters should be an array or object`)
      }

      if (Array.isArray(items)) {
        for (let i = 0; i < items.length; i++) {
          const item = items[i]

          if (typeof item !== 'string') {
            throw new SchemaError(`parameter set_of_strings's items array in parameters should be strings`)
          }
        }
      }

      if (isPlainObject(items)) {
        const query = items.query
        if (typeof query !== 'string') {
          throw new SchemaError(`parameter set_of_strings's items object's query in parameters should be a string`)
        }

        const datasource = items.datasource
        const library = items.library
        const package = items.package

        if ((!!datasource + !!library + !!package) !== 1) {
          throw new SchemaError(`datasource, library and package are mutually exclusive`)
        }

        if (datasource && typeof datasource !== 'string') {
          throw new SchemaError(`datasource should be a string`)
        }

        if (library && typeof library !== 'string') {
          throw new SchemaError(`library should be a string`)
        }

        if (package && typeof package !== 'string') {
          throw new SchemaError(`package should be a string`)
        }
      }
    }

    if (parameter.type === ParameterTypes.NUMBER) {
      if (parameter.default && typeof parameter.default !== 'number') {
        throw new SchemaError(`parameter number's default in parameters should be a number`)
      }
    }

    if (parameter.type === ParameterTypes.OBJECT) {
      if (parameter.default && !isPlainObject(parameter.default)) {
        throw new SchemaError(`parameter object's default in parameters should be a object`)
      }

      if (parameter.key && !isPlainObject(parameter.key)) {
        throw new SchemaError(`parameter object's key in parameters should be a object`)
      } else if (parameter.key) {
        if (typeof parameter.key.placeholder !== 'string') {
          throw new SchemaError(`parameter object's key's placeholder in parameters should be a string`)
        }
      }

      if (!isPlainObject(parameter.value)) {
        throw new SchemaError(`parameter object's value in parameters should be a object`)
      }

      if (parameter.value.placeholder && typeof parameter.value.placeholder !== 'string') {
        throw new SchemaError(`parameter object's value's placeholder in parameters should be a string`)
      }

      const valueTypes = [ParameterTypes.STRING, ParameterTypes.SET_OF_STRINGS, ParameterTypes.SET_OF_NUMBERS]
      if (!valueTypes.includes(parameter.value.type)) {
        throw new SchemaError(`unknown parameter object's value's type in parameters`)
      }

      if (parameter.default && parameter.value.type === ParameterTypes.STRING) {
        const values = Object.values(parameter.default)
        for (let i = 0; i < values.length; i++) {
          const value = values[i]

          if (typeof value !== 'string') {
            throw new SchemaError(`parameter object's default object values in parameters should be strings`)
          }
        }
      }

      if (parameter.default && parameter.value.type === ParameterTypes.SET_OF_STRINGS) {
        const values = Object.values(parameter.default)
        for (let i = 0; i < values.length; i++) {
          const value = values[i]

          if (!Array.isArray(value)) {
            throw new SchemaError(`parameter object's default object values in parameters should be an array`)
          }

          if (!value.every((v) => typeof v === 'string')) {
            throw new SchemaError(`parameter object's default object values in parameters should be an array of strings`)
          }
        }
      }

      if (parameter.default && parameter.value.type === ParameterTypes.SET_OF_NUMBERS) {
        const values = Object.values(parameter.default)
        for (let i = 0; i < values.length; i++) {
          const value = values[i]

          if (!Array.isArray(value)) {
            throw new SchemaError(`parameter object's default object values in parameters should be an array`)
          }

          if (!value.every((v) => typeof v === 'number')) {
            throw new SchemaError(`parameter object's default object values in parameters should be an array of numbers`)
          }
        }
      }
    }
  }
}

function checkPolicy(policy) {
  if (!isPlainObject(policy)) {
    throw new SchemaError('policy must be an object')
  }

  if (!isPlainObject(policy.rule)) {
    throw new SchemaError('policy -> rule must be an object')
  }

  if (typeof policy.rule.type !== 'string') {
    throw new SchemaError('policy -> rule -> type must be a string')
  }

  if (policy.rule.type !== 'rego') {
    throw new SchemaError(`unknown policy -> rule -> type "${policy.rule.type}"`)
  }

  if (typeof policy.rule.value !== 'string') {
    throw new SchemaError('policy -> rule -> value must be a string')
  }
}

const decisionTypes = ['toggle', 'rego', 'string']
function checkDecision(decision) {
  if (!Array.isArray(decision)) {
    throw new SchemaError('decision must be an array')
  }

  for (let i = 0; i < decision.length; i++) {
    const entry = decision[i]

    if (!isPlainObject(entry)) {
      throw new SchemaError('every entry in decision must be an object')
    }

    if (!decisionTypes.includes(entry.type)) {
      throw new SchemaError('unknown entry type in decision')
    }

    if (entry.type === 'rego' || entry.type === 'string') {
      if (typeof entry.key !== 'string' || typeof entry.value !== 'string') {
        throw new SchemaError(`key and value in decision entry type ${entry.type} should be strings`)
      }
    }

    if (entry.type === 'toggle') {
      if (!entry.label) {
        throw new SchemaError(`decision entry type ${entry.type} should have a label field`)
      }

      if (typeof entry.label !== 'string') {
        throw new SchemaError(`decision entry type ${entry.type}'s label should be a string`)
      }

      const toggles = entry.toggles
      if (!Array.isArray(toggles)) {
        throw new SchemaError(`decision entry type ${entry.type}'s toggles should be an array`)
      }

      for (let i = 0; i < toggles.length; i++) {
        const toggle = toggles[i]

        if (!isPlainObject(toggle)) {
          throw new SchemaError(`decision entry type ${entry.type}'s toggles entry should be an object`)
        }

        if (typeof toggle.key !== 'string') {
          throw new SchemaError(`decision entry type ${entry.type}'s toggles entry key should be a string`)
        }

        if (typeof toggle.value !== 'boolean') {
          throw new SchemaError(`decision entry type ${entry.type}'s toggles entry value should be a boolean`)
        }
      }
    }
  }
}

function checkMetadata(yaml, outcome) {
  const metadata = Yaml.load(yaml)
  // console.log(metadata)
  const {title, description, policy, schema} = metadata

  try {
    if (typeof title !== 'string' || typeof description !== 'string') {
      throw new SchemaError('title and description of the snippet must be strings')
    }

    const decision = schema?.decision
    if (decision) {
      checkDecision(decision)
    }

    if (policy) {
      checkPolicy(policy)
    }

    const parameters = schema?.parameters
    if (parameters) {
      checkParameters(parameters)
    }

    println(`✅ pass ${truncate(outcome.filename)}:${outcome.location.line}`)
  } catch (error) {
    if (error instanceof SchemaError) {
      println(`❌ Failed ${truncate(outcome.filename)}:${outcome.location.line}`)
      outcome.errors.push(error)
    } else {
      throw error
    }
  }
}

function checkFile(filename, rego, outcomes) {
  const comments = rego.split('\n').reduce((prev, curr, i) => {
    if (curr.trim().startsWith('#')) {
      prev.push({value: curr.trim().replace('#', ''), location: {start: {line: i+1}, end: {line: i+1}}})
    }

    return prev
  }, [])

  for (let i = 0, n = comments.length; i < n; ++i) {
    const head = comments[i]
    let end = head.location.end
    let yaml = ''

    try {
      if (/^ METADATA: library-snippet/.test(head.value)) {
        for (++i; i < n; ++i) {
          const {location, value} = comments[i]

          if (location.start.line - end.line === 1) {
            // We’re still in the same block of comments that started with
            // 'METADATA: library-snippet'.
            end = location.end
            yaml += `${value.replace(/^ (.*)/, '$1')}${Os.EOL}`
          } else {
            --i; break
          }
        }

        const outcome = {errors: [], filename, location: head.location.start, yaml}
        // console.log(yaml)
        checkMetadata(yaml, outcome, outcomes)
        outcomes.push(outcome)
      }
    } catch (error) {
      println(`❌ fail ${truncate(filename)}:${head.location.start.line}`)
      outcomes.push({errors: [error], filename, location: head.location.start, yaml})
    }
  }
}

function checkFiles(pathname, callback, outcomes = [], pending = new Set()) {
  stat(pathname).then((stats) => {
    if (stats.isDirectory()) {
      pending.add(pathname)

      readdir(pathname).then((items) => {
        pending.delete(pathname)

        items.forEach((item) => {
          checkFiles(Path.join(pathname, item), callback, outcomes, pending)
        })
      })
    } else if (stats.isFile() && Path.basename(pathname) !== Path.basename(pathname, '.rego')) {
      pending.add(pathname)

      readFile(pathname, {encoding: 'utf-8'}).then((rego) => {
        pending.delete(pathname)
        checkFile(pathname, rego, outcomes)

        if (pending.size === 0) {
          callback(outcomes)
        }
      })
    } else if (pending.size === 0) {
      callback(outcomes)
    }
  }).catch((error) => {
    pending.delete(pathname)

    println(`❌ fail ${truncate(pathname)}`)
    outcomes.push({errors: [error], filename: pathname})
  })
}

function truncate(pathname) {
  if (libdir) {
    return pathname.replace(new RegExp(`^${libdir}`), '...')
  }

  return pathname
}

let libdir = ''

if (Fs.realpathSync(process.argv[1]) === __filename) {
  // Executed as script.
  libdir = process.argv[2]

  checkFiles(libdir, (outcomes) => {
    outcomes.sort((a, b) => {
      return a.filename === b.filename
        ? a.location.line - b.location.line
        : a.filename < b.filename ? -1 : 1
    })

    let nFails = 0

    outcomes.forEach(({errors, filename, location, yaml}) => {
      if (errors.length > 0) {
        println(`❌ fail ${truncate(filename)}${location ? `:${location.line}` : ''}`)

        errors.forEach((error) => {
          println(`--> ${error.message}`)
        })

        if (yaml) {
          println(`    ${yaml.split(Os.EOL).join(`${Os.EOL}    `)}`)
        }

        nFails += errors.length
      }
    })

    process.exit(nFails)
  })
}
