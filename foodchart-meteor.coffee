People = new Meteor.Collection("people")

if Meteor.isClient
  chartBalance = () ->
    balances = People.find({}).map (p) -> p.balance
    balances.reduce ((a, b) -> a + b), 0

  chartIsBalanced = () ->
    chartBalance() == 0

  Template.people.people = ->
    People.find({})

  Template.people.chartStatusStyle = ->
    if chartIsBalanced()
      'style="display:none;"'
    else
      'style="display:block;"'

  Template.person.deleteButtonStyle = ->
    if (this.balance == 0) && chartIsBalanced()
      'style="display:inline-block;"'
    else
      'style="display:none;"'

  Template.person.events =
    'click .increment': (event) ->
      People.update(this._id, {$set: {balance: this.balance + 1}})

    'click .decrement': (event) ->
      People.update(this._id, {$set: {balance: this.balance - 1}})

    'click .btn-delete': (event) ->
      People.remove(this._id)

  createPerson = (template) ->
    input_el = template.find('#person-name-input')
    error_el = template.find('#person-name-error')
    if input_el.value
      People.insert
        name: input_el.value
        balance: 0
      input_el.value = ''
      error_el.innerText = ''
    else
      error_el.innerText = "can't be blank"
      $('#person-form-group').addClass('error')

  Template.form.events =
    'keyup .btn-delete': (event, template) ->
      if event.type == "keyup" && event.which == 13
        createPerson(template)
        event.preventDefault()

    'click .btn-submit': (event, template) ->
      createPerson(template)
      event.preventDefault()


if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup
