function populateServices() {
    var categorySelect = document.getElementById("categoryOptions");
    var serviceSelect = document.getElementById("serviceOptions");
    var selectedCategory = categorySelect.value;

    // Clear existing options
    serviceSelect.innerHTML = "";

    // Populate new options
    if (servicesByCategory[selectedCategory]) {
        servicesByCategory[selectedCategory].forEach(function(service) {
            var option = document.createElement("option");
            option.value = service[0];
            option.text = service[1];
            serviceSelect.appendChild(option);
        });
    }
}

window.addEventListener("DOMContentLoaded", function() {
    var today = new Date();
    var minDate = new Date(today);
    minDate.setDate(today.getDate() + 3);
    var maxDate = new Date(today);
    maxDate.setMonth(today.getMonth() + 3);

    var minDateStr = minDate.toISOString().split('T')[0];
    var maxDateStr = maxDate.toISOString().split('T')[0];
    
    var dateSelector = document.getElementById('dateSelector');
    if (dateSelector) {
        dateSelector.setAttribute('min', minDateStr);
        dateSelector.setAttribute('max', maxDateStr);
    }

});


function checkOut() {
    var checkboxes = document.querySelectorAll('input[name="selectedItems"]');
    var anyChecked = Array.from(checkboxes).some(checkbox => checkbox.checked);
    if (!anyChecked) {
        checkboxes.forEach(checkbox => checkbox.checked = true);
    }
    document.getElementById('checkoutForm').action = 'processCheckout.jsp';
    document.getElementById('checkoutForm').submit();
}