<cvrf>
    <h3 class="text-primary">CVE for Triage</h3>

    <div>
        <h4>Request Criteria  <small>in RHEL security DB</small></h4>
        <form id="myform1" class="form-inline" onsubmit={ doRhelGrab }>
            <label for="basic-url">Since Date:</label>
            <div class="input-group date" data-provide="datepicker">
                <input type="text" class="form-control">
                <div class="input-group-addon">
                    <span class="glyphicon glyphicon-th"></span>
                </div>
            </div>
            <label for="exampleInputName2">Severity</label>
            <div class="btn-group">
                <button id="severity" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Level <span class="caret"></span>
                </button>
                <ul class="dropdown-menu">
                    <li class="active"><a href="#">Critical</a></li>
                    <li><a href="#">Important</a></li>
                    <li><a href="#">Moderate</a></li>
                    <li><a href="#">Low</a></li>
                </ul>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:24px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ items.length }>

            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Index</th>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Info</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>Index</th>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Info</th>
                    </tr>
                </tfoot>
                <tbody>
                    <tr each="{ value, i in items }">
                        <td>#{ i }</td>
                        <td>{ value.released_on }</td>
                        <td>{ value.RHSA }</td>
                        <td>{ value.severity }</td>
                        <td>{ value.released_packages }</td>
                        <td><a href="{ convert2htmllink(value.resource_url) }">link</a></td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ items.length == 0 }>
            <div class="alert alert-info">No CVRF emitted.</div>
        </div>
    </div>


    <script type="text/javascript">

        this.items = [];
        this.isLoading = true;
        this.error = null;

        var self = this

        convert2htmllink = function(jsonlink) {

            // https://access.redhat.com/documentation/en/red-hat-security-data-api/version-0.1/red-hat-security-data-api/
            // remove '.json' in URL to get link hat will return data in plain HTML 
            return jsonlink.replace(/\.json$/, "");
            // return jsonlink;
        }

        doRhelGrab = function() {

            console.log("XXXXXXXXXX");

            var x = document.getElementById("myForm1").elements
            for (elem in x) {
                console.log(elem);
            }

            var startDate = document.getElementById("dateFrom").value; 
            var severity = document.getElementById("severity").value;

            var criteria = "";
            criteria.concat("after=", startDate);
            criteria.concat("severity=", severity);

            console.log("start: ", startDate);
            console.log("severity: ", severity);
            console.log("criteria: ", criteria);

            doApiRequest(criteria);
        }

        doApiRequest = function(criteria = null) {
            var url = "/api/cvrf";
            if (criteria !== null && !criteria.empty()) {
                url += criteria;
            }

            $.getJSON(url, function(results) {
                console.log(results);
                self.items = results.data;
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
                $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            $('.datepicker').datepicker();

            doApiRequest();
        })

    </script>

</cvrf>
