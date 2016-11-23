<rheltriageit>
  
    <hr>

    <div if={ isLoading } class='loader center'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ data.length }>

            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
<!--                 <thead>
                    <tr>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </tfoot> -->
                <tbody>
                    <tr>
                        <td>{ data.RHSA }</td>
                        <td>{ data.released_on }</td>
                        <td>{ data.severity }</td>
                        <td>{ data.note }</td>
                        <td>{ data.released_packages }</td>
                        <td><a href="{ data.rhel_weblink }">RHEL link</a></td>
                    </tr>
                </tbody>
            </table>
            <hr>
            <h3>Decision</h3>
            <form id="myform1" class="form" onsubmit={ doSubmit } action="#">
                <div class="form-group">
                    <label for="iddecision">Severity:</label>
                    <select id="iddecision" class="form-control" name="decision" required>
                        <option value="accept">Accept</option>
                        <option value="reject">Reject</option>
                        <option value="unknown">Don't Know</option>
                    </select>
                </div>
                <textarea class="form-control" placeholder="Some Comment" rows="3"></textarea>
                <button type="submit" class="btn btn-success">Apply</button>
            </form>

        </div>
        <div if={ data == null || data.length == 0 }>
            <div class="alert alert-info">No data received.</div>
        </div>
    </div>


    <script>

        this.cvrf = null;
        this.data = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        doRhelGrab() {

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doGetApiRequest(queryparams);
        }

        doApiGetRequest(cvrf) {

            var apiurl = "/api/rheltriage/" + cvrf;

            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                console.log(results);
                self.data = results.data;
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
            });
        }

        doApiPostRequest(cvrf) {

            var apiurl = "/api/rheltriage/" + cvrf;

            self.isLoading = true;
            self.update();

            $.postJSON(apiurl, function(results) {
                console.log(results);
                self.data = results.data;
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
            });
        }

        self.on('mount', function() {

            self.cvrf = opts.cvrf;
            self.doApiGetRequest(self.cvrf);
        })

    </script>

</rheltriageit>
