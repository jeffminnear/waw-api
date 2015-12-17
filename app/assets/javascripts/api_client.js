// Wrap in anonymous function to avoid adding variables to global scope needlessly.
(function($) { // $ is jQuery

  function addGoalToDOM(data) { // 'data' is object built from response JSON

    // id will be needed when adding delete functionality dynamically.
    // var goalId = data.todo.id;


    var goalElement = '<div id="goal-' + data.goal.id + '" class="media">' +
                      '<div class="media-body"><div class="goal goal-ok">' +
                      '<h4 class="media-heading">' + data.goal.name + '</h4>' +
                      '<button data-delete-goal-button="true" data-goal-id="' + data.goal.id + '"' +
                      '>Completed</button><br>' +
                      '<small>7 days left to complete</small></div></div></div>';
    var goalsWrapper = $("[data-goals]");
    // Add HTML for new goal to document
    goalsWrapper.append(goalElement);
  };

  function clearForm() {
    // Clear input field
    var descriptionInput = $("#goal_name");
    descriptionInput.val("");
  };

  function handleError(error) {
    // Relies on error response from API being JSON object like:
    // { errors: [ "Error message", "Another error message" ] }
    var errorsObj = $.parseJSON(error.responseText)
    var errorMessages = errorsObj.errors;
    alert("There was an error: " + errorMessages);
  };

  // function getAuthToken() {
  //   // meta tag in <head> holds auth token
  //   // <meta name="auth-token" content="TOKEN GOES HERE">
  //   var authToken = $("meta[name=auth-token]").attr("content");
  //   return authToken;
  // };
  // function getEmail() {
  //   return "jeff@test.com";
  // }
  //
  // function getPassword() {
  //   return "somethingelse";
  // }

  // ONLY needed if using HTTP Basic authentication:
  // function getHttpBasicAuth() {
  //   // getUsername() and getPassword() will need to be written.
  //   var encodedCredentials = window.btoa(unescape(encodeURIComponent(getEmail() + ':' + getPassword())));
  //   return 'Basic ' + encodedCredentials;
  // }

  function createGoal(event) {
    // Prevent click from triggering form submission default behaviour
    event.preventDefault();

    var nameInput = $("#goal_name");
    var name = nameInput.val();
    var goal = { "goal" : { "name": name } };

    var ajaxOptions = {
      type: "POST", // HTTP verb, one of: POST, DELETE, PATCH, PUT, GET
      // headers: { "Authorization": getHttpBasicAuth() },
      // headers: { "Authorization": getAuthToken() },
      url: "/api/goals",
      dataType: "json",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify(goal)
    };

    // Initiate the AJAX request
    // Docs: http://api.jquery.com/jQuery.ajax/
    $.ajax(ajaxOptions).done([addGoalToDOM, clearForm]).fail(handleError);
  };

  function deleteGoal(event) {
    console.log('delete goal called');
    event.preventDefault();

    // Get the delete button that was clicked (event.target) and
    // wrap it in a jQuery object.
    var clickedElement = $(event.target);

    // The delete button needs a data-goal-id attribute, e.g.
    // <button data-goal-id="7" data-delete-goal-button="true">Delete</button>
    var goalId = clickedElement.data("goal-id");

    var ajaxOptions = {
      type: "DELETE",
      // headers: { "Authorization": getHttpBasicAuth() },
      // headers: { "Authorization": getAuthToken() },
      url: "/api/goals/" + goalId,
      dataType: "json",
      contentType: "application/json; charset=utf-8"
    };

    function removeGoalFromDOM() {
      // Assumes that the delete button is a child element of the
      // todo's table row.
      var goalElement = $('#goal-' + goalId);
      goalElement.remove();
    };

    $.ajax(ajaxOptions).done(removeGoalFromDOM).fail(handleError);
  };

  function setupGoalHandlers() {
    $(document).on("click", "[data-create-goal-button]", createGoal);

    // <%= button_to "Delete", delete_todo_path(todo),
    //       method: :delete, data: { :"delete-todo-button" => true, :"todo-id" => todo.id  } %>
    $(document).on("click", "[data-delete-goal-button]", deleteGoal);
  };
  setupGoalHandlers();

})(jQuery); // IIFE (Immediately Invoked Function Expression)
// Pass in jQuery to prevent other code from changing what $ means to this code above.
